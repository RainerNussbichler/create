/******************************************************************************
* 
* gui.h
*
* user am date
*
******************************************************************************/

#ifndef GUI_H__
#define GUI_H__

#include <QWidget>

class Gui : public QWidget
{
    Q_OBJECT

public:
    Gui(QWidget* parent = nullptr);
    ~Gui();
};

#endif /* GUI_H__ */
