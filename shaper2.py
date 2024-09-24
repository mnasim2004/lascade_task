

import cv2
import numpy as np
import pyvista as pv
from fastapi import FastAPI, File, UploadFile
from fastapi.responses import FileResponse
import os
import trimesh

app = FastAPI()

def stl_to_glb(stl_file, glb_file):
    # Load the STL file
    mesh = trimesh.load_mesh(stl_file)

    # Check if the mesh is empty
    if mesh.is_empty:
        raise ValueError("The provided STL file is empty or not valid.")

    # Export to GLB format
    mesh.export(glb_file, file_type='glb')

@app.post("/process-image/")
async def process_image(file: UploadFile = File(...)):
    # Read the uploaded image
    contents = await file.read()
    np_image = np.frombuffer(contents, np.uint8)
    image = cv2.imdecode(np_image, cv2.IMREAD_COLOR)
    
    if image is None:
        return {"error": "Could not process the image."}

    # Convert to grayscale and apply edge detection
    gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    edges = cv2.Canny(gray, 50, 150)
    contours, _ = cv2.findContours(edges, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

    # Define extrusion height
    extrusion_height = 15.0

    # Create a PyVista plotter
    plotter = pv.Plotter(off_screen=True)  # Off-screen rendering

    # Collect all extruded bodies
    all_bodies = []

    # Loop through contours
    for contour in contours:
        points = contour[:, 0, :]

        # Create a filled polygon from 2D points
        points_2d = np.array(points)
        points_3d = np.pad(points_2d, [(0, 0), (0, 1)])  # Pad to make 3D

        # Define the face for the filled polygon
        face = [len(points_2d)] + list(range(len(points_2d)))  # Cell connectivity
        polygon = pv.PolyData(points_3d, faces=face)

        # Extrude along the z-axis and add the mesh
        body = polygon.extrude((0, 0, extrusion_height), capping=True)
        all_bodies.append(body)

    # Combine all bodies into one mesh
    combined_mesh = all_bodies[0].merge(all_bodies[1:])

    # Save the combined mesh to an STL file
    stl_filename = "output.stl"
    combined_mesh.save(stl_filename)

    # Convert STL to GLB
    glb_filename = "output.glb"
    stl_to_glb(stl_filename, glb_filename)

    # Return the GLB file as a response
    return FileResponse(glb_filename, media_type='application/octet-stream', filename=glb_filename)

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="127.0.0.1", port=8000)

