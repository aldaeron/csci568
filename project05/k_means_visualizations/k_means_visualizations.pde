/*
CSCI Fall 2011 Project 5
A visualization of the K-Means Clustering Algorithm to determine the ideal K
Matt O'Neal
Last Updated 2011-09-26
All code contained in this document is original, except as indicated otherwise
*/

import processing.video.*;

MovieMaker video_output;  // Declare MovieMaker object
	
BufferedReader input_file;
String input_data_line;
String trimmed_input_data_line;
String[] input_data_list;
String[] point_list;
String[] dimension_titles;

int data_size;
int data_dimensions;
float[][] data_set;


float[][][][] cluster_statistics;  // Indicies are [k][iteration}[cluster][stat}
float[][][][] cluster_centroids;   // Indicies are [k][iteration}[cluster][dimension]
int[][][][] cluster_points;      // Indicies are [k][iteration}[cluster][point_list]


int i;
int data_point_index;
int graph_height = 160;
int graph_width = 160;
int graph_vertical_spacing = 30;
int graph_horizontal_spacing = 30;

int data_dimension_index;
int k_min;
int k_max;
int max_iterations;
int k;
int iteration;
float[] range_min;
float[] range_max;
float[] range;
int cluster_number;

int k_display;
int iteration_display;

boolean video_finalized;

void setup() {
    //This code happens once, right when our sketch is launched
    size(880,880);
    


    video_output = new MovieMaker(this, width, height, "k_means_vis.mov", 30);
    video_finalized = false;
   
    input_file = createReader("test.txt");
    
    do {
        input_data_line = read_line(input_file);        

        if(input_data_line != null) {
            if(input_data_line.equals("START-DATA-SET")) {
                while( !(input_data_line.equals("END-DATA-SET")) && (input_data_line != null) ) {
                    input_data_line = read_line(input_file);                
                              
                    input_data_list = split(input_data_line, ":");

                    if(input_data_list[0].equals("NUM-DIMENSIONS")) {
                        data_dimensions = int(input_data_list[1]);
                        dimension_titles = new String[data_dimensions];
                    } else if(input_data_list[0].equals("K-MIN")) {
                        k_min = int(input_data_list[1]);
                    } else if(input_data_list[0].equals("K-MAX")) {
                        k_max = int(input_data_list[1]);
                    } else if(input_data_list[0].equals("ITERATION-MAX")) {
                        max_iterations = int(input_data_list[1]);
                    } else if(input_data_list[0].equals("NUM-DATA-POINTS")) {
                        data_size = int(input_data_list[1]);
                        // Dimension is in the file first
                        // This is probably not the best way to do this, but it will work for now
                        data_set = new float[data_size][data_dimensions];
                    } else if(input_data_list[0].equals("DIMENSION-LABEL")) {
                        dimension_titles[int(input_data_list[1])] = input_data_list[2];
                    } else if(input_data_list[0].equals("DATA-POINT")) {
                        point_list = split(input_data_list[2],",");
                        for( i=0 ; i<data_dimensions ; i++) {
                            data_set[int(input_data_list[1])][i] = float(point_list[i]);
                        }
                    }
                }
                
                if(input_data_line.equals("END-DATA-SET")) {
                    // Initialialize the arrays if we hit the "END-DATA-SET" marker
                    // These are sized for the largest pieces (wasting some memory), but Java is FUCKING STUPID for making hashes and arrays

                    cluster_statistics = new float[k_max-k_min+1][max_iterations][k_max][3];  // There are currently 3 stats per cluster
                    cluster_centroids = new float[k_max-k_min+1][max_iterations][k_max][data_dimensions];
                    cluster_points = new int[k_max-k_min+1][max_iterations][k_max][data_size];
                        
                    range_min = new float[data_dimensions];
                    range_max = new float[data_dimensions];
                    range = new float[data_dimensions];
                }

            } else if(input_data_line.equals("START-ITERATION")) {
                while( !(input_data_line.equals("END-ITERATION")) && (input_data_line != null) ) {  
                    input_data_line = read_line(input_file);
                
                    input_data_list = split(input_data_line, ":");
                
                    if(input_data_list[0].equals("K")) {
                        k = int(input_data_list[1]);
                        iteration = int(input_data_list[3]);
                    } else if(input_data_list[0].equals("CLUSTER-START")) {
                      cluster_number = int(input_data_list[1]);

                      while( !(input_data_line.equals("CLUSTER-END")) && (input_data_line != null) ) {  
                          input_data_line = read_line(input_file);
                          input_data_list = split(input_data_line, ":");
                          
                          if(input_data_list[0].equals("CLUSTER-POINT_LIST")) {
                              point_list = split(input_data_list[1],",");
                              for( i=0 ; i<point_list.length ; i++) {
                                  cluster_points[k-k_min][iteration][cluster_number][i] = int(point_list[i]);
                              }
                          } else if(input_data_list[0].equals("CLUSTER-CENTROID_LIST")) {
                              point_list = split(input_data_list[1],",");
                              for( i=0 ; i<data_dimensions ; i++) {
                                  cluster_centroids[k-k_min][iteration][cluster_number][i] = float(point_list[i]);
                              }
                          } else if(input_data_list[0].equals("CLUSTER-SSE")) {
                              cluster_statistics[k-k_min][iteration][cluster_number][0] = float(input_data_list[1]);
                          } else if(input_data_list[0].equals("CLUSTER-SSB")) {
                              cluster_statistics[k-k_min][iteration][cluster_number][1] = float(input_data_list[1]);
                          } else if(input_data_list[0].equals("CLUSTER-Density")) {
                              cluster_statistics[k-k_min][iteration][cluster_number][2] = float(input_data_list[1]);
                          }
                      }
                
                    }  // For now assume that the convergence method is "Converged" and ignore the convergence methods
                }
            }
        }
    } while (input_data_line != null);
    

    // Find the ranges for each dimension
    for( data_dimension_index=0 ; data_dimension_index<data_dimensions ; data_dimension_index++ ) {
        range_min[data_dimension_index] = Float.MAX_VALUE;
        range_max[data_dimension_index] = 0.0;
        for( data_point_index=0 ; data_point_index<data_size ; data_point_index++ ) {
            if(data_set[data_point_index][data_dimension_index] < range_min[data_dimension_index]) {
                range_min[data_dimension_index] = data_set[data_point_index][data_dimension_index];
            }
            
            if(data_set[data_point_index][data_dimension_index] > range_max[data_dimension_index]) {
                range_max[data_dimension_index] = data_set[data_point_index][data_dimension_index];
            }
        }
        range[data_dimension_index] = range_max[data_dimension_index] - range_min[data_dimension_index];
    }

    k_display = k_min;
    iteration_display = 0;


}

void draw() {
    //This code happens once every frame.
  
    if( (k_display<=k_max) && (iteration_display<max_iterations) ) {

        background(128, 128, 128);
        smooth();

        display_k_means_clusters(k_display, iteration_display, data_set, data_size, data_dimensions, range_min, range_max, range, k_min, cluster_statistics, cluster_centroids, cluster_points, graph_vertical_spacing, graph_horizontal_spacing, graph_height, graph_width, dimension_titles);
  
        textAlign(LEFT);
        fill(0,0,0);
        text("K-means Visualization K: "+k_display+" Iteration: "+iteration_display,0,24);    
        //save("k_means_vis_k_"+k_display+"_iter_"+iteration_display+".jpeg");
        video_output.addFrame();
        
        /*try {
            Thread.sleep(100);
        } catch(InterruptedException e) {
            e.printStackTrace();
        }*/
        
        iteration_display++;
        if(iteration_display >= max_iterations) {
            k_display++;
            iteration_display = 0;
        }
    } else {
        if(video_finalized == false) {
            video_output.finish();
            video_finalized = true;
            println("Video done!");
        }
    }
  
}


void display_k_means_clusters(int k, int iteration, float[][] data_set, int data_size, int data_dimensions, float[] range_min, float[] range_max, float[] range, int k_min, float[][][][] cluster_statistics, float[][][][] cluster_centroids, int[][][][] cluster_points, int graph_vertical_spacing, int graph_horizontal_spacing, int graph_height, int graph_width, String[] dimension_titles) {
    int graph_bottom_left_vertical, graph_bottom_left_horizontal;
    int horizontal_graph_index, vertical_graph_index;
    int cluster_index;
    int cluster_point_index, data_point_index;
  
    int[][] color_set = new int[][] {
      {255,0,0},      // Red
      {0,255,0},      // Green
      {0,0,255},      // Blue
      {255,102,0},    // Orange
      {0,255,255},    // Cyan
      {255,0,255},    // Magenta
      {218,165,32},   // Goldenrod
      {160,32,240},   // Purple
      {255,105,180}   // Pink
    };
  
    PFont centroid_marker = createFont("Helvetica",30);
    PFont axis_labels = createFont("Helvetica",18);
    
    for( vertical_graph_index=0 ; vertical_graph_index<data_dimensions ; vertical_graph_index++) {
        for( horizontal_graph_index=0 ; horizontal_graph_index<data_dimensions ; horizontal_graph_index++) {
            graph_bottom_left_horizontal = (graph_width+2*graph_horizontal_spacing)*horizontal_graph_index + graph_horizontal_spacing;
            graph_bottom_left_vertical = ((graph_height+2*graph_vertical_spacing)*vertical_graph_index + graph_vertical_spacing) + graph_height;


            
            if(vertical_graph_index != horizontal_graph_index) {
                stroke(0, 0, 0);
                fill(255, 255, 255);
                rect(graph_bottom_left_horizontal, graph_bottom_left_vertical - graph_height, graph_width, graph_height);

                textAlign(LEFT);
                textFont(axis_labels);
                text(dimension_titles[horizontal_graph_index], graph_bottom_left_horizontal, graph_bottom_left_vertical + 20 );

                translate(graph_bottom_left_horizontal - 10, graph_bottom_left_vertical);
                rotate(-1*HALF_PI);
                textAlign(LEFT);
                textFont(axis_labels);
                //text(dimension_titles[vertical_graph_index], graph_bottom_left_horizontal - 20, graph_bottom_left_vertical );
                text(dimension_titles[vertical_graph_index], 0, 0 );
                rotate(HALF_PI);
                translate(-1*(graph_bottom_left_horizontal - 10), -1*(graph_bottom_left_vertical));

                for( cluster_index=0 ; cluster_index<k ; cluster_index++) {
                    stroke(color_set[cluster_index][0], color_set[cluster_index][1], color_set[cluster_index][2]);
                    fill(color_set[cluster_index][0], color_set[cluster_index][1], color_set[cluster_index][2]);
                    for( data_point_index=0 ; data_point_index<data_size ; data_point_index++ ) {
                        for( cluster_point_index=0 ; cluster_point_index<data_size ; cluster_point_index++ ) {  // This is terrible, but shitty Java has no easy way to do contains() or in_array()
                            if(cluster_points[k-k_min][iteration][cluster_index][cluster_point_index] == data_point_index) {
                                //ellipse(graph_bottom_left_horizontal + (graph_width*((cluster_centroids[k-k_min][iteration][cluster_index][horizontal_graph_index]-range_min[horizontal_graph_index])/range[horizontal_graph_index])), graph_bottom_left_vertical - (graph_height*((cluster_centroids[k-k_min][iteration][cluster_index][vertical_graph_index]-range_min[vertical_graph_index])/range[vertical_graph_index])), 5, 5);
                                ellipse(graph_bottom_left_horizontal + (graph_width*((data_set[data_point_index][horizontal_graph_index]-range_min[horizontal_graph_index])/range[horizontal_graph_index])), graph_bottom_left_vertical - (graph_height*((data_set[data_point_index][vertical_graph_index]-range_min[vertical_graph_index])/range[vertical_graph_index])), 2, 2);
                            }
                        }
                    }
                    // Put Centroid as a plus "+"
                    textAlign(CENTER);
                    textFont(centroid_marker);
                    text("+",graph_bottom_left_horizontal + (graph_width*cluster_centroids[k-k_min][iteration][cluster_index][horizontal_graph_index]), graph_bottom_left_vertical - (graph_height*cluster_centroids[k-k_min][iteration][cluster_index][vertical_graph_index]));
                    
                }
            }
        }
    }
}


String read_line(BufferedReader input_file) {
    String input_data_line;
    try {
        input_data_line = input_file.readLine();
    } catch (IOException e) {
        e.printStackTrace();
        input_data_line = null;
    }
    return input_data_line;
}
