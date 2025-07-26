from PIL import Image, ImageDraw
import os

# Цвет фона (пример: синий-фиолетовый градиент)
BG_COLOR = (102, 126, 234)  # #667eea
CHECK_COLOR = (255, 255, 255)
ICON_SIZES = [48, 72, 96, 144, 192, 512, 1024, 180, 120, 167, 152, 76, 60, 40, 29]

# Папка для сохранения
os.makedirs('app_icons_simple', exist_ok=True)

def draw_checkmark(draw, size, thickness=0.13):
    # Координаты для галочки (относительно размера)
    w, h = size, size
    # Плавные края: скругление концов
    line_width = int(size * thickness)
    # Галочка: две линии
    # Левая часть
    draw.line(
        [(w*0.28, h*0.55), (w*0.45, h*0.72)],
        fill=CHECK_COLOR, width=line_width, joint="curve"
    )
    # Правая часть
    draw.line(
        [(w*0.45, h*0.72), (w*0.75, h*0.32)],
        fill=CHECK_COLOR, width=line_width, joint="curve"
    )

def create_icon(size):
    img = Image.new('RGBA', (size, size), BG_COLOR)
    draw = ImageDraw.Draw(img)
    # Скругленные углы
    radius = int(size * 0.28)
    mask = Image.new('L', (size, size), 0)
    mask_draw = ImageDraw.Draw(mask)
    mask_draw.rounded_rectangle([(0,0),(size,size)], radius=radius, fill=255)
    img.putalpha(mask)
    # Галочка
    draw_checkmark(draw, size)
    img.save(f'app_icons_simple/icon_{size}.png')

for s in ICON_SIZES:
    create_icon(s)

print('✅ Простые иконки с цветным фоном и белой галочкой с плавными краями созданы!')
