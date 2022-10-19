#include "ros/ros.h"
#include "std_msgs/String.h"
#include "geometry_msgs/Twist.h"
#include "turtlesim/Pose.h"
#include "geometry_msgs/Vector3.h"
#include "csignal"
#include <sstream>
#include <fstream>
#include <cstdlib>
#include <iostream>
#include <cstring>
#include <string>
using namespace std;


void muestraCoordenadasCallback(const turtlesim::Pose& coordenadas)
{
  ROS_INFO_STREAM("Linear X: " << coordenadas.x << " Y: " << coordenadas.y << " theta: " << coordenadas.theta);
}

void signalHandler(int signum) {
  ROS_INFO_STREAM("CERRANDO NODO");
  ros::shutdown();
  exit(0);
}


int main(int argc, char **argv)
{
  char buffer[100];
  geometry_msgs::Twist datos_velocidad;
  ifstream fichero;
  
  ros::init(argc, argv, "practica");
  ros::NodeHandle n;
  ROS_INFO_STREAM("COMIENZA NODO");
  ros::Publisher pub = n.advertise<geometry_msgs::Twist>("turtle1/cmd_vel", 1000);
  ros::Subscriber sus = n.subscribe("turtle1/pose", 1000, muestraCoordenadasCallback);
  ros::Rate loop_rate(10);

  
  
  fichero.open("/home/viki/Tortuga_ws/src/tortugo/src/Datos.txt");

  if(!fichero){

  	cout << "No se ha podido abrir el archivo. (" << endl;
        exit(EXIT_FAILURE);
  }

 
  while (ros::ok() && fichero>>buffer){
    

    //ROS_INFO_STREAM("   ");
    datos_velocidad.linear.x = atof(buffer);
    fichero >> datos_velocidad.linear.y >> datos_velocidad.linear.z >>  datos_velocidad.angular.x >> datos_velocidad.angular.y;
    
    /*datos.linear.x = atof(buffer);

    fichero >> buffer;
    datos.linear.y = atof(buffer);
    
    fichero >> buffer;
    datos.linear.z = atof(buffer);
 
    fichero >> buffer;
    datos.angular.x = atof(buffer);
    
    fichero >> buffer;
    datos.angular.y = atof(buffer);
    */
    fichero >> buffer;
    datos_velocidad.angular.z = atof(buffer);
    
    /*ROS_INFO_STREAM(datos.linear.x);
    ROS_INFO_STREAM(datos.linear.y);
    ROS_INFO_STREAM(datos.linear.z);
    ROS_INFO_STREAM(datos.angular.x);
    ROS_INFO_STREAM(datos.angular.y);
    ROS_INFO_STREAM(datos.angular.z);
    */
    pub.publish(datos_velocidad);
    
    
    ros::spinOnce();

    loop_rate.sleep();
  }
  
   fichero.close();
   signalHandler(0);
   ros::spin();
  return 0;
}
