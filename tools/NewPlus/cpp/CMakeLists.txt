cmake_minimum_required(VERSION 3.10)
project(MyProject)


find_package(Eigen3 3.3 REQUIRED NO_MODULE)
find_package(OpenCV REQUIRED)
find_package(PCL 1.8 REQUIRED)

# 必要な設定をして実行可能ファイルを作成
function(add_my_executable target_name cpp_path)
    add_executable(${target_name} ${cpp_path})
    target_compile_features(${target_name} PUBLIC cxx_std_17)
    target_compile_options(${target_name} PUBLIC
      -Wall -Wextra -Wshadow -Wconversion -Wfloat-equal -Wno-char-subscripts
      -ftrapv -fno-sanitize-recover
      $<$<CONFIG:Debug>: -g>
      $<$<CONFIG:Release>: -mtune=native -march=native -mfpmath=both -O2>)
endfunction()

# OpenCV の依存性を追加
function(use_opencv target_name)
    target_include_directories(
        ${target_name} PRIVATE ${OpenCV_INCLUDE_DIRS})
    target_link_libraries(
        ${targe_name} PRIVATE ${OpenCV_LIBS})
endfunction()

# PCL の依存性を追加
function(use_pcl target_name)
    target_include_directories(${target_name} PRIVATE ${PCL_INCLUDE_DIRS}) 
    target_link_libraries(${target_name} PRIVATE ${PCL_LIBRARIES})
    target_compile_definitions(${target_name} PRIVATE ${PCL_DEFINITIONS})
endfunction()

add_my_executable(main main.cpp)
target_include_directories(main PRIVATE ${EIGEN3_INCLUDE_DIR})
use_opencv(main)
use_pcl(main)
