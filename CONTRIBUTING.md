# Contribuir
¡Gracias por tu interés en contribuir! Agradecemos todas las contribuciones, ya sea a través de correcciones de errores, mejoras de código, documentación, o nuevas características. A continuación te explico cómo puedes contribuir al proyecto.

## ¿Cómo contribuir?
1. Ve a la página principal del repositorio en GitHub.
2. Haz clic en el botón Fork en la esquina superior derecha de la página.
3. Clona tu fork localmente:
```bash
git clone https://github.com/efds24/MetaTSP.git
cd MetaTSP
```
4. Crea una nueva rama para realizar tus cambios. Asegúrate de que el nombre de la rama sea descriptivo y que refleje la naturaleza del cambio que vas a realizar:
```bash
git checkout -b nombre-de-tu-rama
```
Ejemplos de nombres de ramas:

* ``fix/algoritmo-genetico-bug``
* ``feature/nuevo-algoritmo-colonia-de-hormigas``
* ``docs/mejora-documentacion``
5. Realiza los cambios

6. Sincroniza tu fork con el repositorio principal. Si el repositorio principal ha cambiado desde que lo clonaste, asegúrate de actualizar tu fork para evitar conflictos de fusión. Puedes sincronizarlo con el repositorio principal utilizando los siguientes comandos:
```bash
git fetch origin
git rebase origin/main
```
7. Envía un Pull Request (PR)
   
Cuando estés listo, sube tus cambios a GitHub y crea un Pull Request:
```bash
git push origin nombre-de-tu-rama
```
- Ve a la página de tu fork en GitHub.
- Haz clic en el botón Compare & pull request.
- En el campo de descripción, explica detalladamente tus cambios.
- Envía el PR.
8. Revisión de tu PR
  
Tu Pull Request será revisado por los mantenedores del proyecto. Es posible que te pidamos realizar cambios o proporcionar aclaraciones. Una vez aprobado, tu contribución será fusionada al repositorio principal.

9. Después de la fusión
    
Una vez que tu Pull Request sea aceptado y fusionado, ¡puedes eliminar tu rama local y la rama remota de tu fork si ya no las necesitas!
```bash
git checkout main
git branch -d nombre-de-tu-rama
git push origin --delete nombre-de-tu-rama
```
 Si encuentras un error y no estás seguro de cómo solucionarlo, abre un issue en GitHub. Proporciona la mayor cantidad de detalles posible, incluyendo:

- Descripción del problema.
- Cómo reproducir el problema (pasos claros).
- Comportamiento esperado y comportamiento observado.
- Sugerencias de nuevas características
- Si tienes una idea para una nueva característica o mejora, abre un issue en GitHub.
