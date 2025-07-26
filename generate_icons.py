#!/usr/bin/env python3
from PIL import Image, ImageDraw
import os

def create_app_icon():
    # Create 512x512 image
    size = 512
    img = Image.new('RGB', (size, size), color='white')
    draw = ImageDraw.Draw(img)
    
    # Background gradient (simplified as solid color)
    bg_color = '#667eea'
    
    # Draw rounded rectangle background
    draw.rounded_rectangle([(0, 0), (size, size)], radius=108, fill=bg_color)
    
    # Draw white paper
    paper_rect = [(96, 80), (416, 480)]
    draw.rounded_rectangle(paper_rect, radius=16, fill='white')
    
    # Draw lines on paper
    line_color = '#e5e7eb'
    for i in range(8):
        y = 140 + i * 40
        draw.line([(130, y), (382, y)], fill=line_color, width=2)
    
    # Draw completed checkbox
    checkbox_rect = [(130, 125), (150, 145)]
    draw.rounded_rectangle(checkbox_rect, radius=4, fill='#22c55e')
    
    # Draw checkmark (simplified)
    draw.line([(135, 135), (140, 140)], fill='white', width=3)
    draw.line([(140, 140), (145, 130)], fill='white', width=3)
    
    # Draw empty checkboxes
    checkbox2_rect = [(130, 165), (150, 185)]
    draw.rounded_rectangle(checkbox2_rect, radius=4, fill='white', outline='#d1d5db', width=2)
    
    checkbox3_rect = [(130, 205), (150, 225)]
    draw.rounded_rectangle(checkbox3_rect, radius=4, fill='white', outline='#d1d5db', width=2)
    
    # Draw task text lines (as rectangles)
    draw.rounded_rectangle([(160, 128), (280, 136)], radius=4, fill='#10b981')
    draw.rounded_rectangle([(160, 138), (240, 144)], radius=3, fill='#6ee7b7')
    
    draw.rounded_rectangle([(160, 168), (300, 176)], radius=4, fill='#6b7280')
    draw.rounded_rectangle([(160, 178), (260, 184)], radius=3, fill='#9ca3af')
    
    draw.rounded_rectangle([(160, 208), (320, 216)], radius=4, fill='#6b7280')
    draw.rounded_rectangle([(160, 218), (280, 224)], radius=3, fill='#9ca3af')
    
    # Draw header decoration
    draw.rounded_rectangle([(115, 100), (397, 104)], radius=2, fill=bg_color)
    
    return img

def main():
    # Create assets directory if it doesn't exist
    assets_dir = 'assets/icons'
    os.makedirs(assets_dir, exist_ok=True)
    
    # Create and save the icon
    icon = create_app_icon()
    icon.save(f'{assets_dir}/app_icon.png', 'PNG')
    print(f"Icon saved to {assets_dir}/app_icon.png")
    
    # Create smaller versions for different uses
    sizes = [16, 32, 48, 64, 128, 256]
    for size in sizes:
        small_icon = icon.resize((size, size), Image.Resampling.LANCZOS)
        small_icon.save(f'{assets_dir}/app_icon_{size}x{size}.png', 'PNG')
        print(f"Icon {size}x{size} saved")

if __name__ == '__main__':
    main()
