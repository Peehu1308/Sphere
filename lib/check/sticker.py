from PIL import Image

img = Image.open("your_image.jpg")
img = img.convert("RGBA")
img = img.resize((512, 512))
img.save("sticker.png", format="PNG")
