#!/usr/bin/env python3.9

# python visualize-mapping-changes.py 2023-01-13.track_mapping_changes.sorted.flexible-change-in-mapq/2023-01-13.2022-12-13.track_mapping_changes.2-graphs-only.include-mapping-nodes.interleave-mappings.flexible-change-in-mapq.output.analyze-mappings.gaining_mapq.gaining_accuracy.txt ../graph.xg ../graph.spoa.normalized.xg 2023-01-13.track_mapping_changes.sorted.flexible-change-in-mapq/visualize_graphs.gaining_mapq.gaining_accuracy/

import argparse
import ast
import subprocess
import random

tmp_file_randint = random.randint(0,999999)


def see_if_too_long(mappings):
    primary_mapping_keys = ["unnormalized_primary", "normalized_primary"]
    secondary_mapping_keys = ["unnormalized_secondary", "normalized_secondary"]
    mapping_key_list = primary_mapping_keys + secondary_mapping_keys
    for mapping_key in mapping_key_list:
        # if mapping_key in secondary_mapping_keys:
        #     # there may be multiple secondary mappings.
        # print("mapping_key", mapping_key)
        if mapping_key in secondary_mapping_keys:
            for mapping in mappings[mapping_key]:
                # print("mapping", mapping)
                for mapping_end in mapping:
                    if len(mapping_end["path"]) > 30:
                        return True #too long
        else: #mapping key in primary_mapping_keys:
            for mapping_end in mappings[mapping_key]:
                if len(mapping_end["path"]) > 30:
                    return True #too long

    return False
    

def make_all_svgs(infile, unnormalized_graph_file, normalized_graph_file, unnorm_gam_file, norm_gam_file, outfile_base_name, context_size):
    for line in infile:
        read_name = line.split("\t")[0]
        #todo: remove debug
        # if read_name != "seed_12345_fragment_26822":
        #     continue

        mappings = ast.literal_eval(line.split("\t")[1])
        # print(mappings)
        #todo: remove debug
        # if see_if_too_long(mappings):
        #     # print("too long!")
        #     continue
        primary_mapping_keys = ["unnormalized_primary", "normalized_primary"]
        secondary_mapping_keys = ["unnormalized_secondary", "normalized_secondary"]
        mapping_key_list = primary_mapping_keys + secondary_mapping_keys
        # subprocess.run(["echo", "hello", "world", "hello world, how are you doing?"])

        mappings_list = mappings
        read_list = list()
        # print("mappings", mappings)

        # unnormalized_graph_file = sys.argv[2] #must be xg
        # normalized_graph_file = sys.argv[3] #must be xg
        # gam_file = sys.argv[4] #ideally a smallish gam file, so that subsetting the gam takes less time.
        # outfile_base_name = sys.argv[5]
        # context_size = 4

        for mapping_key in mapping_key_list:
            # if mapping_key in secondary_mapping_keys:
            #     # there may be multiple secondary mappings.
            # print("mapping_key", mapping_key)
            if mapping_key in secondary_mapping_keys:
                secondary_read_number = 1
                for mapping in mappings[mapping_key]:
                    # print("mapping", mapping)
                    read_pair_number = 0
                    for mapping_end in mapping:
                        # print("mapping_end", mapping_end)

                        mapping_quality = mapping_end["mapping_quality"] #todo: only include this info if mapping_quality isn't "NA". Or rather, always make mapping quality the value of the one that isn't "NA".
                        correctly_mapped = mapping_end["correctly_mapped"]
                        read_pair_number += 1
                        outfile_name = outfile_base_name + "." + read_name + "." + mapping_key.split("_")[0] + "." + mapping_key.split("_")[1] + "."  + "read-pair-" + str(read_pair_number) + "." + "mapping-quality-" + str(mapping_quality) + "." + "correctly-mapped-" + str(correctly_mapped) + "." + "secondary-read-" + str(secondary_read_number) + "." + "reference-position-" + str(min(mapping_end["reference_position"])) + "-" + str(max(mapping_end["reference_position"])) + "." "node-start-end-" + str(min(mapping_end["path"])) + "-" + str(max(mapping_end["path"])) + ".svg"

                        node_list = mapping_end["path"] #TODO: need this to be input format expected by vg find.

                        if mapping_key.split("_")[0] == "unnormalized":
                            make_svg(unnormalized_graph_file, outfile_name, outfile_base_name, read_name, node_list, unnorm_gam_file, context_size)
                        else: #mapping_key is "normalized":
                            make_svg(normalized_graph_file, outfile_name, outfile_base_name, read_name, node_list, norm_gam_file, context_size)
                    secondary_read_number += 1

            else: #mapping key in primary_mapping_keys:
                read_pair_number = 0
                for mapping_end in mappings[mapping_key]:
                    # print("mapping_end", mapping_end)

                    mapping_quality = mapping_end["mapping_quality"] #todo: only include this info if mapping_quality isn't "NA". Or rather, always make mapping quality the value of the one that isn't "NA".
                    correctly_mapped = mapping_end["correctly_mapped"]
                    read_pair_number += 1
                    outfile_name = outfile_base_name + "." + read_name + "." + mapping_key.split("_")[0] + "." + mapping_key.split("_")[1] + "." + "read-pair-" + str(read_pair_number) + "." + "mapping-quality-" + str(mapping_quality) + "." + "correctly-mapped-" + str(correctly_mapped) + "." + "reference-position-" + str(min(mapping_end["reference_position"])) + "-" + str(max(mapping_end["reference_position"])) + "." "node-start-end-" + str(min(mapping_end["path"])) + "-" + str(max(mapping_end["path"])) + ".svg"

                    node_list = mapping_end["path"] #TODO: need this to be input format expected by vg find.
                    if mapping_key.split("_")[0] == "unnormalized":
                        make_svg(unnormalized_graph_file, outfile_name, outfile_base_name, read_name, node_list, unnorm_gam_file, context_size)
                    else: #mapping_key is "normalized":
                        make_svg(normalized_graph_file, outfile_name, outfile_base_name, read_name, node_list, norm_gam_file, context_size)



def make_svg(graph_file, outfile_name, outfile_base_name, read_name, node_list, gam_file, context_size):


    print("Making svg called:", outfile_name)
    node_args = list()
    for node in node_list:
        node_args.append("-n")
        node_args.append(str(node))

    vg_find_command = ["vg", "find", "-c", str(context_size), "-x", graph_file] + node_args
    # print("running vg find: ", vg_find_command)
    vg_find = subprocess.Popen(vg_find_command, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    vg_find_output = vg_find.communicate()
    # print("stdout from vg_find_output", vg_find_output[0])
    # print("stderr from vg_find_output", vg_find_output[1])
    ## print("debug: stdout (note, program will NOT work with this print uncommented.", vg_find.stdout.read().decode())
    # print("stderr: ", vg_find.stderr.read().decode())

    # print("gam file is ", gam_file)
    vg_filter_command = ["vg", "filter", "-n", read_name + "_", gam_file]
    # print("running vg_filter", vg_filter_command)
    # vg_filter = subprocess.Popen(vg_filter_command, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    vg_filter_tmp_file = outfile_base_name + "." "visualize-mapping-changes." + str(tmp_file_randint) + ".vg-filter-tmp.txt"
    with open(vg_filter_tmp_file, "w") as vg_filter_tmp_inf:
        vg_filter = subprocess.Popen(vg_filter_command, stdout=vg_filter_tmp_inf, stderr=subprocess.PIPE)
        vg_filter_output = vg_filter.communicate()
        # print("stdout from vg_filter_output", vg_filter_output[0])
    # print("stderr from vg_filter_output", vg_filter_output[1])
    # print(vg_filter_output)

    # print()

    # vg_view_command = ["vg", "view", "-dp", "-"]
    vg_view_command = ["vg", "view", "-A", vg_filter_tmp_file, "-dp", "-"]
    # print("running vg view: ", vg_view_command)
    vg_view = subprocess.Popen(vg_view_command, stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    vg_view_output = vg_view.communicate(vg_find_output[0])
    # print("stdout from vg_view_output", vg_view_output[0])
    # print("stderr from vg_view_output", vg_view_output[1])

    rm_tmp_file_command = ["rm", vg_filter_tmp_file]
    rm = subprocess.Popen(rm_tmp_file_command)
    
    # vg_view.wait()
    ## print("debug: stdout (note, program will NOT work with this print uncommented.", vg_view.stdout.read().decode())
    # print("stderr: ", vg_view.stderr.read().decode())

    dot_command = ["dot", "-Tsvg"]
    # print("running dot: ", dot_command)
    with open(outfile_name, "w") as outf:
        # print("outfile_name", outfile_name)
        # dot = subprocess.Popen(dot_command, stdin=vg_view_output[0].decode(), stdout=outf, stderr=subprocess.PIPE)
        # dot = subprocess.Popen(dot_command, stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        dot = subprocess.Popen(dot_command, stdin=subprocess.PIPE, stdout=outf, stderr=subprocess.PIPE)
        vg_dot_output = dot.communicate(vg_view_output[0])
        # print("stdout from vg_dot_output", vg_dot_output[0])
        # print("stderr from vg_dot_output", vg_dot_output[1])

        
                                        # ls_command = ["ls", "-alt", "small_test"]
                                        # ls = subprocess.Popen(ls_command, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
                                        # ls_output = ls.communicate()

                                        # # print(ls_output)
                                        # echo_command = ["echo", "hello"]
                                        # echo_command = ["echo", "hello", ls_output[0]]
                                        # echo = subprocess.Popen(echo_command)
                                        # echo.communicate()



                                    #        # print("debug: stdout (note, program will NOT work with this print uncommented.", dot.stdout.read().decode())
                                            # print("stderr: ", dot.stderr.read().decode())


                                        # vg_find_command = ["vg", "find", "-c", str(context_size), "-x", graph_file] + node_args
                                        # print("running vg find: ", vg_find_command)
                                        # vg_find = subprocess.Popen(vg_find_command, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
                                        # vg_find.wait()
                                        # ## print("debug: stdout (note, program will NOT work with this print uncommented.", vg_find.stdout.read().decode())
                                        # print("stderr: ", vg_find.stderr.read().decode())

                                        # vg_view_command = ["vg", "view", "-dp", "-"]
                                        # print("running vg view: ", vg_view_command)
                                        # vg_view = subprocess.Popen(vg_view_command, stdin=vg_find.stdout, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
                                        # vg_view.wait()
                                        # ## print("debug: stdout (note, program will NOT work with this print uncommented.", vg_view.stdout.read().decode())
                                        # print("stderr: ", vg_view.stderr.read().decode())


                                        # vg_find_command = ["vg", "find", "-c", str(context_size), "-x", graph_file] + node_args
                                        # print("running vg find: ", vg_find_command)
                                        # vg_find = subprocess.Popen(vg_find_command, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
                                        # # vg_find = subprocess.Popen(vg_find_command)
                                        # # vg_find.wait()
                                        # ## print("debug: stdout (note, program will NOT work with this print uncommented.", vg_find.stdout.read().decode())
                                        # # vg_find_output = vg_find.communicate()
                                        # # print("stderr: ", vg_find_output[1].decode())
                                        # # # print("stdout:", vg_find_output[0])

                                        # vg_view_command = ["vg", "view", "-dp", "-"]
                                        # print("running vg view: ", vg_view_command)
                                        # vg_view = subprocess.Popen(vg_view_command, stdin=vg_find.stdout, stdout=subprocess.PIPE, stderr=subprocess.PIPE)

                                        # vg_view = subprocess.Popen(vg_view_command, stdin=vg_find.stdout, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
                                        # # vg_view = subprocess.Popen(vg_view_command, stdin=vg_find_output[0].decode())
                                        # # vg_view.wait()
                                        # ## print("debug: stdout (note, program will NOT work with this print uncommented.", vg_view.stdout.read().decode())
                                        # vg_view_output = vg_view.communicate()
                                        # print("stderr: ", vg_view_output[1].decode())
                                        # # print("stderr: ", vg_view.stderr.read().decode())

                                    #     dot_command = ["dot", "-Tsvg"]
                                    #     print("running dot: ", dot_command)
                                    #     with open(outfile_name, "w") as outf:
                                    #         print("outfile_name", outfile_name)
                                    #         # dot = subprocess.Popen(dot_command, stdin=vg_view_output[0].decode(), stdout=outf, stderr=subprocess.PIPE)
                                    #         dot = subprocess.Popen(dot_command, stdin=vg_view.stdout, stdout=outf, stderr=subprocess.PIPE)
                                    #         # dot.wait()
                                    # #        # print("debug: stdout (note, program will NOT work with this print uncommented.", dot.stdout.read().decode())
                                    #         print("stderr: ", dot.stderr.read().decode())

                                        # # vg_find.wait()
                                        # # vg_view.wait()
                                        # # dot.wait()

                                        # if (vg_find.returncode | vg_view.returncode | dot.returncode):
                                        #     print("ERROR: nonzero return for one of the subprocesses:")
                                        #     print("vg_find return:", vg_find.returncode)
                                        #     print("vg_view return:", vg_view.returncode)
                                        #     print("dot return:", dot.returncode)
                                        #     exit()


def main():
    parser = argparse.ArgumentParser()

    #required
    parser.add_argument("-a", "--analyze_mappings", type=str, help="the output of analyze-mappings.separate-mapping-entries.py")
    parser.add_argument("-u", "--unnorm_graph", type=str, help="the unnormalized graph file.")
    parser.add_argument("-n", "--norm_graph", type=str, help="the normalized graph file.")
    parser.add_argument("-f", "--unnorm_gam", type=str, help="a gam file containing all the reads of interest mapped to the unnorm_graph in the analyze-mappings output")
    parser.add_argument("-g", "--norm_gam", type=str, help="a gam file containing all the reads of interest mapped to the unnorm_graph in the analyze-mappings output")
    parser.add_argument("-o", "--outfile_prefix", type=str, help="the base of all the outfile names. Can include directories.")

    #optional
    parser.add_argument("-c", "--context_size", default="4", type=str, help="Dermines the -c option for vg find. I.e., how many steps of context to give the graph viz from the target nodes. Default=4.")

    args = parser.parse_args()
    
    # with open(sys.argv[1]) as inf:
    with open(args.analyze_mappings) as inf:
        make_all_svgs(inf, args.unnorm_graph, args.norm_graph, args.unnorm_gam, args.norm_gam, args.outfile_prefix, args.context_size)

if __name__ == "__main__":
    main()
