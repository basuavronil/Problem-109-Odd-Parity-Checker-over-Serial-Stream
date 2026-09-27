# Problem-109-Odd-Parity-Checker-over-Serial-Stream
## Odd Parity Checker over Serial Stream

A digital circuit (FSM) that watches a stream of bits one at a time and outputs `1` whenever the count of `1`s seen so far (since reset) is odd — basically a running parity flag.

## Output 
### Waveform 
<img width="959" height="236" alt="image" src="https://github.com/user-attachments/assets/0ead3026-3114-485d-93a5-9d7607e9f258" />

* **Initialization & Reset:** When active reset (`rst`) is asserted HIGH at startup, the FSM initializes to the `EVEN` state (`0`), driving `parity_odd` low (`0`).
* **Parity Tracking:** Upon reset deassertion, each incoming `1` on `bit_in` toggles the internal `state` and `parity_odd` output on the rising clock edge, correctly asserting HIGH whenever an odd count of `1`s is detected.


### Simulation terminal
<img width="805" height="192" alt="image" src="https://github.com/user-attachments/assets/c8e3182d-24fc-4322-82bf-34990e1b1557" />

