#include<stdio.h>
#include<stdlib.h>

int main(int argc, char *argv[]){

  FILE *output;

  if(remove("test_slice.conf") == 0){
    printf("file <test_slice.conf> removed\n");
  }

  if((output = fopen("test_slice.conf","a")) == NULL){
    printf("error!\n");
    exit(0);
  }

  if(argc != 4){
    printf("usage: ./make_topology height_nodenumber width_nodenumber slice_unitnum");
    exit(0);
  }

  int height = atoi(argv[1]);
  int width = atoi(argv[2]);
  int slice_unit = atoi(argv[3]);
  int size = height*width;
  int i,j,current = 0;
  int mac[12];

  for(i = 0; i < 12; i++){
    mac[i] = 0;
  }

  for(i=0; i<size; i++){
    int slicenum = i / slice_unit;
    if(i%slice_unit == 0){
      fprintf(output, "slice%d{", slicenum);
    }
    for(j=11; j>=0; j--){
      fprintf(output, "%x", mac[j]);
      if((j%2==0) && (j != 0)){
	fprintf(output, ":");
      }
    }
    if(i%slice_unit == slice_unit-1 || i == size-1){
      fprintf(output, "}\n");
    }
    else{
      fprintf(output, ",");
    }

    mac[0]++;
    while(mac[current] == 16){
      mac[current] = 0;
      current++;
      mac[current]++;
    }
    current = 0;
  }

  fclose(output);
  exit(1);
}
