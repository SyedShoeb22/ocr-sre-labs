import oci
config = oci.config.from_file()
compute_client = oci.core.ComputeClient(config)
resp = compute_client.list_instances(config["compartment_id"])
for i in resp.data:
    print(i.display_name, i.lifecycle_state)
