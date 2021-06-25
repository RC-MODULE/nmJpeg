"# nmJpeg" 

Библиотека JPEG кодирования для NeuroMatrix (nmc3,nmc4)
- Поддреживается только ч/б формат

- зависимости nmpp (hal для примеров )

сборка библиотеки под nmc3 архитектуру:
\nmJpeg\make\jpeg-nmc3 make    (GCC)
\nmJpeg\make\jpeg-nmc3 -f legacy.mk (Legacy)

сборка библиотки под nmc4 архитектуру::
\nmJpeg\make\jpeg-nmc3 make    (GCC)
\nmJpeg\make\jpeg-nmc3 -f legacy.mk (Legacy)

## Сборка NeuroMatrix библиотек  GCC  компилятором (Windows/Linux)
  Сборка библиотек осуществляется командой ```make``` из соответствующей архитектуре папки */make/nmpp-\<archictecture\>* :  

| Команда 									| Результат сборки         |
|-------------------------------------------|--------------------------|
|``` /nmJpeg/make/jpeg-nmc3> make ```  		| nmJpeg/lib/libnmjpeg-nmc3.a  |
|``` /nmJpeg/make/jpeg-nmc4> make ```  		| nmJpeg/lib/libnmjpeg-nmc4.a  |


## Сборка NeuroMatrix библиотек Legacy  компилятором 
  Сборка устаревшим компилятором возможна командой ```make``` с ключом ```legacy``` из соответствующей архитектуре папки */make/jpeg-\<archictecture\>*:   

| Команда 											| Результат сборки 	      |
|-----------------------------------------------	|-------------------------|
|```/nmJpeg/make/jpeg-nmc3> make legacy```  			| nmJpeg/lib/nmjpeg-nmc3.lib  |
|```/nmJpeg/make/jpeg-nmc4> make legacy```  			| nmJpeg/lib/nmjpeg-nmc4.lib  |


## Сборка x86/x64 библиотек  
 Библиотеки выполняют точную эмуляцию функций библотеки nmjpeg под x86/x64. 
 Генерация сборочных файлов/проектов для x86/64 архитектуры в Windows/Linux оcуществляется средствами [**premake5**](https://premake.github.io/).  
Сконфигурировать проект и собрать библиотеку можно одной из команд:   

| Команда                                   | Результат сборки               |
|-------------------------------------------|------------------------------- |
|``` \nmJpeg\make\jpeg-x86> make vs2015```	| nmJpeg\lib\jpeg-x86.lib          |
|											| nmJpeg\lib\jpeg-x86d.lib         | 
|											| nmJpeg\lib\jpeg-x64.lib          |
|											| nmJpeg\lib\jpeg-x64d.lib         |
 


Возможные ключи ```make```:
| Ключ   | ОС      | Toolchain             |
|--------|---------|-----------------------|
| vs2005 | Windows | MS Visual Studio 2005 |
| vs2015 | Windows | MS Visual Studio 2015 |
| vs2017 | Windows | MS Visual Studio 2017 |



## Сборка примеров  
Библиотека nmjpeg использует  [NMPP](https://github.com/RC-MODULE/nmpp) , необходимо собрать соответствующие библиотеки. 
Для сборки  примеров  может быть необходим [HAL](https://github.com/RC-MODULE/hal) со скомпилированными соответствующими библиотеками и прописанной переменной окружения *HAL* и *NMPP*.
 
 
|Действие                       | Команда                                                           | Результат сборки               |
|-------------------------------|-------------------------------------------------------------------|------------------------------- |
|Собрать пример под 5103 legacy	|```\nmjpeg\examples\simple\make_mc5103\> make -f legacy.mk ```		| make_mc5103\>main.abs |
|Запустить пример 				|```\nmjpeg\examples\simple\make_mc5103\> make -f legacy.mk run ```	| make_mc5103\>out.jpg       | 
|Собрать пример под МС12101 GCC	|```\nmjpeg\examples\simple\make_mc12101\> make  ```				| make_mc12101\>main |
|Запустить пример 				|```\nmjpeg\examples\simple\make_mc12101\> make run ```				| make_mc12101\>out.jpg       | 
|Собрать пример под МС12101 legacy|```\nmjpeg\examples\simple\make_mc12101\> make -f legacy.mk run  ```		| make_mc12101\>main.abs |
|Запустить пример 				|```\nmjpeg\examples\simple\make_mc12101\> make -f legacy.mk run run ```	| make_mc12101\>out.jpg       | 



