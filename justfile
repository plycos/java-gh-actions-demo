default target="jre" port="8080":
    just build {{target}}
    just run {{port}}

build target="runtime":
    docker build -t java-demo:latest --target={{target}} .

output:
    mkdir -p .output
    docker build --target output --output type=local,dest=.output .

run port="8080":
    docker run -p {{port}}:8080 java-demo:latest
