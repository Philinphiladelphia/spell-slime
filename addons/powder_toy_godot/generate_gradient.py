from PIL import Image, ImageDraw

# Create a white image
size = 160
gradient_size = 10
image = Image.new('RGBA', (size, size), (255, 255, 255, 255))

# Create a gradient mask
mask = Image.new('L', (size, size), 0)
draw = ImageDraw.Draw(mask)

# Draw gradients on the edges
for i in range(gradient_size):
    alpha = int(255 * (i / gradient_size))
    draw.rectangle([i, i, size - i - 1, size - i - 1], outline=alpha)

# Apply the mask to the image
image.putalpha(mask)

# Save the image
image.save('gradient_edges.png')