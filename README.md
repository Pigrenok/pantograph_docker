# Pantograph graph processing and visualisation docker infrastructure

## Running Pantograph Visualisation tool with Redis DB and DB API.

This repo present an easy way to deploy both Pantograph graph visualisation tool (with its metadata DB and API interface) as well as pyGenGraph python package
for genome graphs construction, processing and exporting to Pantograph Visualisation tool.

In order to run Pantograph, all you need to do is

```bash
git clone ...

cd pantograph_docker
```

Then open `docker-compose.yaml` in your favourite text editor and set up your paths as you would prefer (see comments in docker compose file).

After that just in the main directory where the repo was cloned, just do

```bash
docker compose up -d
```

That is it. Now just head to `http://localhost:8888` and the app is there. There are a couple of examples available in the Pantograph repo (!!!link), which you can download and
try it on. If it will not find data index file, it will not run.

Also, it is set up to use with unsecured HTTP web-server. If you would like to set up sequred SSL server, uncomment marked (with comments) lines in 
`docker-compose.yaml` and read comments at the bottom of the file.

You will need to rerun certbot regularly to renew your certificates.

## Processing graphs using pyGenGraph command line tool `pantograph`

Now, if you would like to generate your own graph or export existing graph you can use extra image for pyGenGraph package with available command line interface.

In order to run it, just do

```bash
docker compose run pantograph --help
```

To get what this command line interface has to offer. Details are available in pyGenGraph repo. `pantograph` container will not run automatically with `docker compose up` and it needs to be run manually with specific parameters. The following examples gives the idea how to use it:


## Examples

### Converting paths to graph

```bash
docker compose run pantograph paths2graph -g /examples/gene_graph/settings.yaml
```

Then set the following parameters in YAML file

```yaml
pathfileDir: /examples/gene_graph
pathFiles:
    Main: paths_genegraph.txt
# pathFile: paths_graph.txt # This line needs to be commented in the sample file!
outputpath: /examples/gene_graph
outputBasename: 'path_genegraph'
```

and then just run

```bash
docker compose run pantograph paths2graph /examples/gene_graph/settings.yaml
```
This should create a graph with extra files in the same directory.

### Converting annotations to graph

In similar way as converting paths to graph, annotations can also be converted to graphs. The requirement is that annotations for various accessions will have some sort of similarity IDs for genes (e.g. if two genes are similar/the same, each gene record should have specific field in GFF file which have the same identificator, at the moment fields OG is searched for, but this can be changed).

In terms of how to use command line tool, it is the same way as for converting paths to graph. You first generate sample setting YAML file and then edit it to fit your case. THe sample YAML file has very extensive description of each parameter.

In order to understand how a graph is formed from annotations, read about Gene Graphs in the user manual.

### Sorting graph

If you already have a graph which you need to sort (make an order of the nodes for visualising it in linearised manner), then you can do the following command in the main repo directory:

```bash
docker compose run pantograph sort-graph --isseq --output /examples/nucleotide_graph/paths_presentation_sorted.gfa /examples/nucleotide_graph/paths_presentation.gfa
```

Do not forget that that it will run Redis server automatically if it is not already running.

### Exporting graph to Pantograph visualisation tool.

In order to export a graph to visualisation tool (running in docker already if you did `docker compose up` before), first you need to generate a sample setting file. Two examples, one for gene graph, and one for nucleotide graph are provided:

#### Exporting gene graph

Generate sample setting file:

```bash
docker compose run pantograph export-vis -g /examples/gene_graph/settings_export.yaml
```

Then change generated file `settings_export.yaml`, which should contain the following uncommented lines:

```yaml
projectID: paths_genegraph
projectName: Sample gene graph
caseDict:
    Main: paths_genegraph_Main.gfa
pathToIndex: /examples/visdata
pathToGraphs: /examples/gene_graph
redisHost: redis
isSeq: False
zoomLevels: [1,2,4]
```

After that you only need to run

```bash
docker compose run pantograph export-vis /examples/gene_graph/settings_export.yaml
```

and that is it.

#### Exporting nucleotide graph

The same principles as before. First, Generate sample setting file:

```bash
docker compose run pantograph export-vis -g /examples/nucleotide_graph/settings_export.yaml
```

Then change generated file `settings_export.yaml`, which should contain the following uncommented lines:

```yaml
projectID: nucleotide_graph
projectName: "Sample nucleotide graph"
caseDict:
    Main: paths_presentation_sorted.gfa
pathToIndex: /examples/visdata
pathToGraphs: /examples/nucleotide_graph
redisHost: 'redis'
zoomLevels: [1,2,4]
```

After that you only need to run

```bash
docker compose run pantograph export-vis /examples/nucleotide_graph/settings_export.yaml
```

and that is it.

### Seeing exported graphs

If you did not started the main docker infrastructure, do

```bash
docker compose up -d
```

Just open your browser and go to `http://localhost:8888` and you should see the following

