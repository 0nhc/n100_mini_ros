cmake_minimum_required(VERSION 3.5)
project(n100_mini_ros)


# Default to C99
if(NOT CMAKE_C_STANDARD)
  set(CMAKE_C_STANDARD 99)
endif()

# Default to C++14
if(NOT CMAKE_CXX_STANDARD)
  set(CMAKE_CXX_STANDARD 14)
endif()

if(CMAKE_COMPILER_IS_GNUCXX OR CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  add_compile_options(-Wall -Wextra -Wpedantic)
endif()

find_package(Eigen3 REQUIRED)
set(Eigen3_INCLUDE_DIRS ${EIGEN3_INCLUDE_DIR})

# find dependencies
find_package(ament_cmake REQUIRED)
find_package(ament_index_cpp REQUIRED)
find_package(rclcpp REQUIRED)
find_package(rclpy REQUIRED)
find_package(sensor_msgs REQUIRED)
find_package(std_msgs REQUIRED)
find_package(tf2 REQUIRED)
find_package(tf2_ros REQUIRED)
find_package(nav_msgs REQUIRED)
find_package(geometry_msgs REQUIRED)
find_package(tf2_geometry_msgs REQUIRED)

add_library(serial_lib
  src/serial/serial.cc
  src/serial/impl/unix.cc
  src/serial/impl/win.cc
  src/serial/impl/list_ports/list_ports_linux.cc
  src/serial/impl/list_ports/list_ports_osx.cc
  src/serial/impl/list_ports/list_ports_win.cc
)

target_include_directories(serial_lib PUBLIC
  include/serial
)

if(BUILD_TESTING)
  find_package(ament_lint_auto REQUIRED)
  # the following line skips the linter which checks for copyrights
  # uncomment the line when a copyright and license is not present in all source files
  #set(ament_cmake_copyright_FOUND TRUE)
  # the following line skips cpplint (only works in a git repo)
  # uncomment the line when this package is not in a git repo
  #set(ament_cmake_cpplint_FOUND TRUE)
  ament_lint_auto_find_test_dependencies()
endif()

include_directories(
  include
  src
  ${catkin_INCLUDE_DIRS}
  ${Eigen3_INCLUDE_DIRS} 
)


add_executable(ahrs_driver_node src/ahrs_driver.cpp src/crc_table.cpp)
target_link_libraries(ahrs_driver_node serial_lib)
ament_target_dependencies(ahrs_driver_node rclcpp rclpy  std_msgs  sensor_msgs tf2_ros tf2 nav_msgs geometry_msgs ament_index_cpp)


add_executable(imu_tf_node src/imu_tf.cpp)
target_link_libraries(imu_tf_node serial_lib)
ament_target_dependencies(imu_tf_node rclcpp rclpy std_msgs sensor_msgs tf2_ros tf2 tf2_geometry_msgs ament_index_cpp)

# find_package(Boost 1.55.0 REQUIRED COMPONENTS system filesystem)
# include_directories(ahrs_driver_node ${Boost_INCLOUDE_DIRS})
# link_directories(ahrs_driver_node ${Boost_LIBRARY_DIRS})
# target_link_libraries(ahrs_driver_node ${Boost_LIBRSRIES})

install(TARGETS
  ahrs_driver_node
  imu_tf_node

  DESTINATION lib/${PROJECT_NAME}
)

install(
  DIRECTORY launch 
  DESTINATION share/${PROJECT_NAME}
)

ament_package()
