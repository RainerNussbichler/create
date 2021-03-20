/******************************************************************************
* 
* main.cpp
*
* user am date
*
******************************************************************************/

#include <QApplication>
#include <QWidget>

#include "headers/gui.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    Gui* gui = new Gui;
    gui->show();
    
    return app.exec();
}
