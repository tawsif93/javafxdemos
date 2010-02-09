@cd dist
@mkdir classes
@mv ProgressListener.jar classes
@cd classes
@jar -xvf ProgressListener.jar
@rm -rf META-INF
@rm ProgressListener.jar
@jar -cvf ProgressListener.jar .
@mv ProgressListener.jar ProgressListener.jar
@cd ../../
@rm -rf dist

@javaws -uninstall
@javaws -uninstall -system
