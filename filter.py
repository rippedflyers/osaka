import demoji

def filter(description):
    '''Custom filter for titles here.'''
    for line in description.split("\n"):
        line = line.strip()
        if line.startswith("[") and line.strip().endswith("]"):
            if(not line.strip() == '[DJ]'):
                return line.strip()
        if line.strip().endswith("」"): return line.strip()
        if line.strip().endswith("』"): return line.strip()
        if(line.strip().endswith("”") and line.strip().startswith("“")):
            return line[1:-1]
        if(line.startswith('"') and line.endswith('"')): return line.strip()
        if " tour" in line.strip().lower():
            return line.strip()
        if " vol." in line.strip().lower():
            return line.strip()
    for line in description.split("\n"):
        line = line.strip()
        if line.endswith('】'): return line
    return None