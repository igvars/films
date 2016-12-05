# Films
===========
Project structure
--------------------
```
Destination           | Description
--------------------- | ----------------------
dist/                 | Compiled
   css/               | Styles
   fonts/             | Fonts
   js/                | Javascripts
src/                  | Source
   coffee/            | Coffeescripts
   js/                | Javascripts are compiled coffescripts via gulp
   scss/              | Sass files
   template/          | Angular page templates
index.html            | Application entry point
node_modules/         | 3rd party libraries go here
gulpfile.js           | Gulp builder config
package.json          | File that store project dependies
README.md             | This readme
```
Instructions
-------------------
For deploy project please follow next steps:
- From project root run
```
npm install
npm update
gulp coffee
gulp
```
- Start front-end http server from (project_root)/ directory
- Open your browser and surf to the http server 
```
http://localhost
```
- You will see an input, just enter movie name and click search button, next you will see the table of movies
Task
--------------------
Реализовать приложение single-page для отображения списка фильмов с RESTapi-ресурса.


Предлагается использовать бесплатный сервис поиска фильмов http://www.omdbapi.com/, но можно возпользоваться любым подобным на ваше усмотрение.


1. Таблица, отображающая список фильмов.
Таблица должна быть оснащена пагинацией в виде "бесконечного" скроллинга (догрузка следующих страниц при скроллинге вниз).


2. Фильтры по имени, году выпуска (см. документацию к сервису).


3. Фильтр по типу (см. документацию к сервису).
Фильтр состоит из радиобаттонов:
Все
Фильм (movie)
Сериал (series)
Эпизод (episode)


По умолчанию выбрано "Все".


4. Страница фильма.
При нажатии на фильм в таблице открывается страница просмотра детальной информации о фильме.
Важно, чтобы каждая страница фильма находилась по отдельному url и при перезагрузке этого урла можно было попасть на соответствующую страницу.
На странице можно отображать ту же информацию, что и в таблице.




Будет плюсом:


кэширование каждого запроса (например, в webstorage). Если такой запрос уже закэширован, то не делать запрос на сервер;
возможность очистки кэша и перезагрузка таблицы с первой страницы;
обработка ошибок от сервиса.
