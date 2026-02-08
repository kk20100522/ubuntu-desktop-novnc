import pygame
import sys

pygame.init()

screen = pygame.display.set_mode((400, 300))
pygame.display.set_caption("Pygame ささ")

while True:
    screen.fill((0, 0, 0))

    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            pygame.quit()
            sys.exit()
    
    pygame.display.flip()