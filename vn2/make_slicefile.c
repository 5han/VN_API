#include<stdio.h>
#include<stdlib.h>
#include<string.h>
FILE *filebuf;
void ArgumentError();
void MakeTopology(int width,int height,int slice_unit);
void Add_slice(int argc,char *argv[]);
void Del_slice(int argc,char *argv[]);
void Add_host(int argc,char *argv[]);
void Del_host(int argc,char *argv[]);
void convert_Mac(int Mac[],int hostnum);
FILE* search_slice_id(int slice_id,FILE* point);

int main(int aint rgc, char *argv[]){
  if(argc < 2){
    ArgumentError();
    exit(1);
  }

  if(strcmp(argv[1],"make") == 0){
    if(argc != 5){
      ArgumentError();
      exit(1);
    }
    int height = atoi(argv[2]);
    int width = atoi(argv[3]);
    int slice_unit = atoi(argv[4]);
    MakeTopology(width,height,slice_unit);
  }else{
    if((filebuf = fopen("test_slice.conf","r+")) == NULL){
      printf("error!\n");
      exit(0);
    }
    if(strcmp(argv[1],"add_slice") == 0){
      Add_slice(argc,argv);
    }else if(strcmp(argv[1],"del_slice") == 0){
      Del_slice(argc,argv);
    }else if(strcmp(argv[1],"add_host") == 0){
      Add_host(argc,argv);
    }else if(strcmp(argv[1],"del_host") == 0){
      Del_slice(argc,argv);
    }else{
      ArgumentError();
      exit(1);
    } 
  }
  fclose(filebuf);
  exit(0);
}

FILE* search_slice_id(int slice_id,FILE *point){
  char line[1024];
  char* tok;
  while(fgets(line,1024,point) != NULL){
    tok = strtok(&line[5],"{");
    if(slice_id == atoi(tok)){
      return point;
    }
  }
  return NULL;
}

void convert_Mac(int Mac[],int hostnum){
  int i = 0;
  Mac[0] = hostnum;
  while(Mac[i] > 16){
    while(Mac[i] > 16){
      Mac[i+1]++;
      Mac[i] -= 16;
    }
    i++;
  }
  return;
}

void ArgumentError(){
  printf("usage: ./make_topology make height_nodenumber width_nodenumber slice_unitnum\n");
  printf("usage: ./make_topology add_slice slice_id\n");
  printf("usage: ./make_topology del_slice slice_id\n");
  printf("usage: ./make_topology add_host slice_id host_name1..\n");
  printf("usage: ./make_topology del_host slice_id host_name1..\n");
  return;
}

void MakeTopology(int width,int height,int slice_unit){
  if((filebuf = fopen("test_slice.conf","w")) == NULL){
    printf("error!\n");
    exit(0);
  }

  int size = height*width;
  int i,j,current = 0;
  int mac[12];

  for(i = 0; i < 12; i++){
    mac[i] = 0;
  }

  for(i=0; i<size; i++){
    int slicenum = i / slice_unit;
    if(i%slice_unit == 0){
      fprintf(filebuf, "slice%d{", slicenum);
    }
    for(j=11; j>=0; j--){
      fprintf(filebuf, "%x", mac[j]);
      if((j%2==0) && (j != 0)){
	fprintf(filebuf, ":");
      }
    }
    if(i%slice_unit == slice_unit-1 || i == size-1){
      fprintf(filebuf, "}\n");
    }
    else{
      fprintf(filebuf, ",");
    }

    mac[0]++;
    while(mac[current] == 16){
      mac[current] = 0;
      current++;
      mac[current]++;
    }
    current = 0;
  }
  return;
}

void Add_slice(int argc,char *argv[]){
  char buf[1000000];
  filebuf = search_slice_id(3,filebuf);
  while((getc(filebuf)) != '{');
  
  return;
}

void Del_slice(int argc,char *argv[]){
  return;
}
void Add_host(int argc,char *argv[]){
  return;
}
void Del_host(int argc,char *argv[]){
  return;
}
