#ifndef DBUSSERVICE_H
#define DBUSSERVICE_H

#include <QObject>

class DBusService : public QObject
{
    Q_OBJECT
public:
    explicit DBusService(QObject *parent = nullptr);
    ~DBusService(){}

signals:

public slots:
    QString getMessage(void);
};

#endif // DBUSSERVICE_H
