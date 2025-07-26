#!/usr/bin/env python3
from PIL import Image, ImageDraw
import os

def create_notification_icon():
    # Create 24x24 notification icon (monochrome)
    size = 24
    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    # Draw simple checkbox icon for notifications
    # Outer border
    draw.rounded_rectangle([(2, 2), (22, 22)], radius=3, outline=(255, 255, 255, 255), width=2)
    
    # Checkmark
    draw.line([(6, 12), (10, 16)], fill=(255, 255, 255, 255), width=2)
    draw.line([(10, 16), (18, 8)], fill=(255, 255, 255, 255), width=2)
    
    return img

def create_large_notification_icon():
    # Create 64x64 large notification icon
    size = 64
    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    # Background circle
    draw.ellipse([(4, 4), (60, 60)], fill=(102, 126, 234, 255))
    
    # White checkbox
    draw.rounded_rectangle([(18, 18), (46, 46)], radius=4, outline=(255, 255, 255, 255), width=2, fill=(255, 255, 255, 255))
    
    # Green checkmark
    draw.line([(24, 32), (30, 38)], fill=(34, 197, 94, 255), width=3)
    draw.line([(30, 38), (40, 26)], fill=(34, 197, 94, 255), width=3)
    
    return img

def main():
    # Create notification icons directory
    drawable_dirs = [
        'android/app/src/main/res/drawable-hdpi',
        'android/app/src/main/res/drawable-mdpi',
        'android/app/src/main/res/drawable-xhdpi',
        'android/app/src/main/res/drawable-xxhdpi',
        'android/app/src/main/res/drawable-xxxhdpi'
    ]
    
    sizes = {
        'drawable-mdpi': 24,
        'drawable-hdpi': 36,
        'drawable-xhdpi': 48,
        'drawable-xxhdpi': 72,
        'drawable-xxxhdpi': 96
    }
    
    large_sizes = {
        'drawable-mdpi': 64,
        'drawable-hdpi': 96,
        'drawable-xhdpi': 128,
        'drawable-xxhdpi': 192,
        'drawable-xxxhdpi': 256
    }
    
    for dir_path in drawable_dirs:
        os.makedirs(dir_path, exist_ok=True)
        
        # Get size for this density
        density = dir_path.split('/')[-1]
        small_size = sizes[density]
        large_size = large_sizes[density]
        
        # Create small notification icon
        small_icon = create_notification_icon()
        small_icon = small_icon.resize((small_size, small_size), Image.Resampling.LANCZOS)
        small_icon.save(f'{dir_path}/ic_notification.png', 'PNG')
        
        # Create large notification icon
        large_icon = create_large_notification_icon()
        large_icon = large_icon.resize((large_size, large_size), Image.Resampling.LANCZOS)
        large_icon.save(f'{dir_path}/ic_notification_large.png', 'PNG')
        
        print(f"Created notification icons for {density}")

if __name__ == '__main__':
    main()
