/*
CSCI Fall 2011 Project 5
A visualization of the K-Means Clustering Algorithm to determine the ideal K
Matt O'Neal
Last Updated 2011-09-26
All code contained in this document is original, except as indicated otherwise
*/

  
	
BufferedReader input_file;
String input_data_line;
String trimmed_input_data_line;
String[] input_data_list;
String[] point_list;
int data_size;
int data_dimensions;
float[][] data_set;
int i;
int horizontal_graph_index, vertical_graph_index;
int graph_height = 160;
int graph_width = 160;
int graph_vertical_spacing = 30;
int graph_horizontal_spacing = 30;
int graph_bottom_left_vertical;
int graph_bottom_left_horizontal;
int data_point_index;
int data_dimension_index;
float[] range_min;
float[] range_max;
float[] range;
  
void setup() {
    //This code happens once, right when our sketch is launched
    size(880,880);
    background(128, 128, 128);
    smooth();
    
    PFont label = createFont("Helvetica", 24);
    fill(0, 102, 153);
    textFont(label);
    
    input_file = createReader("test.txt");
    
    do {
        try {
            input_data_line = input_file.readLine();
        } catch (IOException e) {
            e.printStackTrace();
            input_data_line = null;
        }
        


        if(input_data_line != null) {
            if(input_data_line.equals("START-DATA-SET")) {

              while( !(input_data_line.equals("END-DATA-SET")) && (input_data_line != null) ) {
                    try {
                        input_data_line = input_file.readLine();
                    } catch (IOException e) {
                        e.printStackTrace();
                        input_data_line = null;
                    }
                
                              
                    input_data_list = split(input_data_line, ":");

                
                    if(input_data_list[0].equals("NUM-DIMENSIONS")) {
                        data_dimensions = int(input_data_list[1]);
                    } else if(input_data_list[0].equals("NUM-DATA-POINTS")) {
                        data_size = int(input_data_list[1]);
                        // Dimension is in the file first
                        // This is probably not the best way to do this, but it will work for now
                        data_set = new float[data_size][data_dimensions];
                        range_min = new float[data_dimensions];
                        range_max = new float[data_dimensions];
                        range = new float[data_dimensions];
                    } else if(input_data_list[0].equals("DATA-POINT")) {
                        point_list = split(input_data_list[2],",");
                        for( i=0 ; i<data_dimensions ; i++) {
                            data_set[int(input_data_list[1])][i] = float(point_list[i]);
                        }
                    }
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



    
    for( vertical_graph_index=0 ; vertical_graph_index<data_dimensions ; vertical_graph_index++) {
        for( horizontal_graph_index=0 ; horizontal_graph_index<data_dimensions ; horizontal_graph_index++) {
            graph_bottom_left_horizontal = (graph_width+2*graph_horizontal_spacing)*horizontal_graph_index + graph_horizontal_spacing;
            graph_bottom_left_vertical = ((graph_height+2*graph_vertical_spacing)*vertical_graph_index + graph_vertical_spacing) + graph_height;

            stroke(0, 0, 0);
            fill(255, 255, 255);
            rect(graph_bottom_left_horizontal, graph_bottom_left_vertical - graph_height, graph_width, graph_height);

            if(vertical_graph_index != horizontal_graph_index) {
                stroke(0, 0, 0);
                fill(0, 0, 0); // Eventually color by cluster
                for( data_point_index=0 ; data_point_index<data_size ; data_point_index++ ) {
                    ellipse(graph_bottom_left_horizontal + (graph_width*((data_set[data_point_index][horizontal_graph_index]-range_min[horizontal_graph_index])/range[horizontal_graph_index])), graph_bottom_left_vertical - (graph_height*((data_set[data_point_index][vertical_graph_index]-range_min[vertical_graph_index])/range[vertical_graph_index])), 3, 3);
                }
            }
        }
    }
    
    text("K-means Visualization",0,24);    
    
}

void draw() {
  //This code happens once every frame.
  
}


