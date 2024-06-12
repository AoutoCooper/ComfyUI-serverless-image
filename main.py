import runpod
from comfy_serverless import ComfyConnector

def handler(job):  
    prompt = job["input"]["workflow"] 
    comfy_connector = ComfyConnector()
    images = comfy_connector.generate_images(prompt)
    #create links to the images in my node.js server 
    #return the links 
    #for now, will use a very small workflow and return a 64px image
    return images
    
runpod.serverless.start({"handler": handler})  # Required.