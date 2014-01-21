#include<stdio.h>
#include<stdlib.h>

int main(int argc, char *argv[]){

  FILE *output;

  if(remove("test_topology.conf") == 0){
    printf("file removed\n");
  }

  if((output = fopen("test_topology.conf","a")) == NULL){
    printf("error!\n");
    exit(0);
  }

  if(argc != 3){
    printf("usage: ./make_topology height_nodenumber width_nodenumber");
    exit(0);
  }

  int height = atoi(argv[1]);
  int width = atoi(argv[2]);
  int size = height*width;
  int i,j,current = 0;
  int mac[12];

  for(i = 0; i < 12; i++){
    mac[i] = 0;
  }

  for(i = 0; i < size; i++){
    fprintf(output,"vswitch { dpid \"0x%x\" }\n",i+1);
  }

  for(i = 0; i < size; i++){
    fprintf(output,"vhost(\"host%d\"){\n",i+1);
    fprintf(output," ip \"192.168.0.%d\"\n",i+1);
    fputs(" netmask \"255.255.0.0\"\n mac \"",output);
    for(j=11; j >= 0; j--){
      fprintf(output,"%x",mac[j]);	
      if((j%2 == 0)&&(j != 0)){
	fputs(":",output);
      }
    }
    fputs("\"\n}\n\n",output);
    mac[0]++;
    while(mac[current] == 16){
      mac[current] = 0;
      current++;
      mac[current]++;
    }
    current = 0;
  }

  for(i=0; i< height; i++){
    for(j = 0; j < width; j++){
      if(j != width - 1){
	fprintf(output,"link \"0x%x\",\"0x%x\"\n",width*i+j+1,width*i+j+2);
      }
      if(i != height - 1){
	fprintf(output,"link \"0x%x\",\"0x%x\"\n",width*i+j+1,width*i+j+width+1);
      }
    }
  }

  for(i=0; i < size; i++){
    fprintf(output,"link \"0x%x\",\"host%d\"\n",i+1,i+1);
  }
  fclose(output);
  exit(1);
}
