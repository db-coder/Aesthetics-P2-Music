// Class for a short melody. Supports several visualization, replay, animaiton, mouse or keyboard editing
// Written by Jarek Rossignac on July 14, 2017
import java.util.*;

class TUNE
  {
  int n=8*8; // number of slots for notes or silences
  int [] slot = new int [n]; // notes or silence (if ==-1)
  int s=0; // current slot number for playing
  int f=0; // current frame number since start of tune
  float lm=40, tm=150; // left & top margins
  final int MAX_NUM_OF_NOTES = 64; //we can fit in up to 64 8th notes into the 8 measures
  final int NUM_SEMITONES = 26;    //the notes range from 00 (low A) up to and including 25 (high Bb)
  final int NOTES_PER_MEASURE = 8; //the max. number of notes that can fit into a measures
  
  
  // ********************************************************* CREATION
  TUNE() {reset();}
  void reset() {for(int i=0; i<n; i++) slot[i]=-1;}
  void resetMiddle() {for(int i=16; i<n-16; i++) slot[i]=-1;}
  void create() {for(int i=0; i<n; i++) {slot[i]=i%8;} }
  void makeRandom()
    {
    slot[0]=13; 
    int prev=13;
    for(int i=1; i<n; i++) 
      if(int(random(2))==0) slot[i]=-1; 
      else 
        {
        int c = (2*int(random(2))-1)*2*int(random(int(random(1,4))))+(2*int(random(2))-1)*3*int(random(int(random(1,4)))); 
        if(c==0) c = (2*int(random(2))-1)*2*int(random(int(random(1,4))))+(2*int(random(2))-1)*3*int(random(int(random(1,4)))); 
        if(int(random(0,25))<prev == c>0) c=-c;
        c+=prev;
        if(c>25) c=50-c;
        if(c<0) c=-c;
        slot[i]=c;
        prev=c;
        }
    }
    
  void fillInRandom() 
    {
    int prev=slot[15];
    int x=15;
    while(x>0 && slot[x--]==-1) prev=slot[x]; // look for previous note
    for(int i=16; i<n-16; i++) 
      if(int(random(2))==0) slot[i]=-1; 
      else 
        {
        int c = (2*int(random(2))-1)*2*int(random(int(random(1,4))))+(2*int(random(2))-1)*3*int(random(int(random(1,4))));  
        if(c==0) c = (2*int(random(2))-1)*2*int(random(int(random(1,4))))+(2*int(random(2))-1)*3*int(random(int(random(1,4)))); 
        if(int(random(0,25))<prev == c>0) c=-c;
        c+=prev;
        if(c>25) c=50-c;
        if(c<0) c=-c;
        slot[i]=c;
        prev=c;
        }
    }

  //*********** REPLACE THIS METHOD BELOW WITH STUDENTS' FILL-IN HEURISTIC ***** 
  void myFillIn(){
    //There are a total of 8 possible slots per measure, and a total of 8 measures.
    //Each "measure" can be thought of as 4/4 time signature, and we can fit up to eight 8th notes. (16th notes not possible)
    //Formally, slot[i] = k, where 0 <= i <= 63, and k = a note value, -1 <= k <= 25 
    //Notes range from 0 (low A) to 25 (high Bb over two octaves up), or -1 for "rest".
    //This range covers two full octaves + one semitone.
    
    //We'll begin by figuring out the most likely key signature and whether the key is in major or minor,
    //based on the notes contained in the beginning 2 + ending 2 measures.
    
    /* These are the semitonic intervals involved in a major scale. This can be transposed to any key signature.
       For example, for an A major scale, we could start at note 0 and ascend as follows:
       0 2 4 5 7 9 11 12
       For a C major scale, we could start at note 3:
       3 5 7 8 10 12 14 15
       and so on.
    */
    int[] major = {2, 2, 1, 2, 2, 2, 1};
    
    //These are the semitonic intervals involved in an ascending melodic minor scale, and can be transposed to any key signature.
    int[] minor_melodic = {2, 1, 2, 2, 2, 2, 1};
    
    //These are the semitonic intervals involved in a natural minor scale, and can be transposed to any key signature.
    int[] minor_natural = {2, 1, 2, 2, 1, 2, 2};
    
    //These are the semitonic intervals involved in a harmonic minor scale (notice the augmented 2nd near the end), and can be transposed to any key signature.
    int[] minor_harmonic = {2, 1, 2, 2, 1, 3, 1};
    
    //We'll initialize a counter (to be employed later when generating notes) that keeps track of 
    //the type of intervals used in the beginning / ending measures. 
    int[] intervals = new int[NUM_SEMITONES];   //intervals[i] = the no. of times a pair of adjacent notes were apart by i semitones.
    int max_interval = 0;
    //We'll also keep track of the index of the last adjacent note (needed in the event of rests)
    int adjnote_beginning_measures = -1;
    int adjnote_ending_measures = -1;
    
    //We'll try every possible key signature and pick one that adheres most closely to one of the above intervals.
    //(TODO - Consider maybe adding a bias towards the ending and/or beginning note most likely being the tonic key?)
    //First, get all the notes in the first two and last two measures into a counter.
    int[] counter = new int[NUM_SEMITONES];         //counter[i] = the no. of times that note i appeared in the beginning 2 + ending 2 measures.
    int minNote = Integer.MAX_VALUE;                //Let's also keep track of the lowest and highest note that appear.
    int maxNote = -1;
    for (int i = 0; i < 16; ++i) {
      if(slot[i] != -1) {                             //-1 indicates a rest sign. We ignore rest signs for this purpose.
        counter[slot[i]]++;                           //get each note in first two measures
        minNote = Math.min(minNote, slot[i]);
        maxNote = Math.max(maxNote, slot[i]);
        
        //Also keep track of intervals for later use
        if (adjnote_beginning_measures == -1) adjnote_beginning_measures = i;
        else {
          int curr_intv = Math.abs(slot[i] - slot[adjnote_beginning_measures]);   //get interval between adjacent pairs of (non-rest) notes
          intervals[curr_intv]++; //update counter
          if (max_interval < curr_intv) max_interval = curr_intv; //update max_interval encountered thus far
          adjnote_beginning_measures = i;  //update adjacent note
        }
      }
      if (slot[MAX_NUM_OF_NOTES-1-i] != -1) {
        counter[slot[MAX_NUM_OF_NOTES-1-i]]++;      //get each note in last two measures
        minNote = Math.min(minNote, slot[MAX_NUM_OF_NOTES-1-i]);
        maxNote = Math.max(maxNote, slot[MAX_NUM_OF_NOTES-1-i]);
        
        //Also keep track of intervals for later use
        if (adjnote_ending_measures == -1) adjnote_ending_measures = MAX_NUM_OF_NOTES-1-i;
        else {
          int curr_intv = Math.abs(slot[MAX_NUM_OF_NOTES-1-i] - slot[adjnote_ending_measures]);  //get interval between adjacent pairs of notes
          intervals[curr_intv]++; //update counter
          if (max_interval < curr_intv) max_interval = curr_intv;  //update max_interval thus far
          adjnote_ending_measures = MAX_NUM_OF_NOTES-1-i;  //update adjacent note
        }
      }
      System.out.printf("adding note %s and %s...\n", i, 63-i);
    }
    System.out.printf("Counter array: %s\n", Arrays.toString(counter));
    System.out.printf("Interval array: %s\n", Arrays.toString(intervals));
    System.out.printf("Max. interval: %s\n", max_interval);
    System.out.printf("Min. and Max. notes: %s(%s) and %s(%s)\n", minNote, getNoteName(minNote), maxNote, getNoteName(maxNote));
    
    //Go thru every key signature, major and minor and compare with counter. We want the one with the least total difference.
    //diff[i][j] = the no. of notes in counter that do NOT match the scale with note i as the tonic, and
    //             where j indicates major scale if j=0, minor_melodic scale if j=1, minor_natural scale if j=2, and minor_harmonic scale if j=3.
    //             i <= 12 because there are 12 semitones in an octave, so this covers every possible tonic.
    int[][] diff = new int[12][4];
    int min_diff = Integer.MAX_VALUE;  //used to keep track of the minimum difference
    ArrayList<Integer[]> contenders = new ArrayList<Integer[]>(); //these will keep track of the key signatures / scales that are most likely to be the best fit.
    
    //similarity[i][j] = the similarity score between counter and the given scale, where i,j is defined as above. This is tracked separately and is used to
    //break ties in the event there are 2 or more contenders with the same difference score.
    int[][] similarity = new int[12][4];
    
    for (int i = 0; i < diff.length; ++i) {
      int[] scale0 = buildScale(i, major, NUM_SEMITONES);         //invoke custom helper method buildScale()
      System.out.printf("major scale starting with key %s(%s) : %s\n", i, getNoteName(i), Arrays.toString(scale0)); //getNoteName() is a custom method
      int[] scale1 = buildScale(i, minor_melodic, NUM_SEMITONES);
      System.out.printf("minor melodic scale starting with key %s(%s) : %s\n", i, getNoteName(i), Arrays.toString(scale1));
      int[] scale2 = buildScale(i, minor_natural, NUM_SEMITONES);
      System.out.printf("minor natural scale starting with key %s(%s) : %s\n", i, getNoteName(i), Arrays.toString(scale2));
      int[] scale3 = buildScale(i, minor_harmonic, NUM_SEMITONES);
      System.out.printf("minor harmonic scale starting with key %s(%s) : %s\n", i, getNoteName(i), Arrays.toString(scale3));
      
      int[][] scales = {scale0, scale1, scale2, scale3};
      
      //Use inner loop to keep track of the key signature / scale(s) with the minimum difference thus far
      for (int j = 0; j < diff[i].length; ++j) {
        diff[i][j] = computeDiff(scales[j], counter);   //computeDiff() is a custom method
        
        System.out.printf("diff[%s][%s] = %s\n", i, j, diff[i][j]);
        if (min_diff > diff[i][j]) {   //If there is a new unique winner so far, clear the list of contenders.
          min_diff = diff[i][j];
          contenders.clear();
          contenders.add(new Integer[]{i,j});
          /* computeSimilarity() is a custom method. To save time, we don't compute the similarity scores
             for every scale -- only for those scales that have a chance to win. */
          similarity[i][j] = computeSimilarity(counter, i, j);
        } else if (min_diff == diff[i][j]) {  //If there is another contender that ties the current min_diff, add to the list of contenders
          contenders.add(new Integer[]{i,j});
          similarity[i][j] = computeSimilarity(counter, i, j);
        }
      }
      //end for j
    }
    //end for i
    
    int max_similarity = 0;
    ArrayList<Integer[]> finalists = new ArrayList<Integer[]>();
    
    //From the list of contenders (each with the minimum difference score), we want to choose "finalists" 
    //-- i.e. those with the max. similarity score
    System.out.printf("contenders (with difference scores of %s each):\n", min_diff);
    for (Integer[] contender : contenders) {
      System.out.print(Arrays.toString(contender) + " ");
      System.out.printf("(Similarity score: %s)\n", similarity[contender[0]][contender[1]]);
      if (similarity[contender[0]][contender[1]] > max_similarity) {
        finalists.clear();
        finalists.add(contender);
        max_similarity = similarity[contender[0]][contender[1]]; 
      } else if (similarity[contender[0]][contender[1]] == max_similarity) {
        finalists.add(contender);
      }
    }
    
    System.out.printf("finalists (with similarity scores of %s each):\n", max_similarity);
    for (Integer[] finalist : finalists) {
      System.out.print(Arrays.toString(finalist) + " ");
    }
    
    Integer[] winner = finalists.get(0);
    //If there are multiple finalists, break tie randomly
    if (finalists.size() > 1) {
      winner = finalists.get((int)(Math.random() * finalists.size()));
    }
    
    System.out.printf("\n\nWinner: %s\n", Arrays.toString(winner));
    System.out.printf("The most likely key signature is: %s %s\n", getNoteName(winner[0]), winner[1] == 0 ? "Major" : "Minor");
    
    /*
    Now that we have the key signature, here is a suggested strategy for generating notes:
    1. Get the intervals between adjacent consecutive notes. We rarely want to exceed the max. interval, and maybe want our
       generated notes to have a range of intervals that are similar in frequency.
    2. We rarely want our generated notes to exceed the lowest and/or the highest note that appeared in the beginning / ending measures.
    3. Look at the rhythms used in the beginning / ending measures. We want to generally stick to the same rhythm
       (including rests and so forth), with some small chance of random mutation mixed in.
    4. With no / few exceptions, our generated notes should be limited to those comprising the key signature we discovered above.  
    */
    
    int total_notes_in_3rd_thru_6th_measures = 0; //let's keep track of how many notes we have to generate in total just in case. We may or may not use this info later
    
    //Copy the rhythm from the ending 2 measures and use it for the 3rd and 4th measure, and
    //copy the rhythm from the beginning 2 measures and use it for the 5th and 6th measure.
    //Just copy the rhythm for now and fill in all the non-rest notes with 0. We'll generate and replace these notes later.
    for (int i = MAX_NUM_OF_NOTES / NOTES_PER_MEASURE * 2; i < MAX_NUM_OF_NOTES - (NOTES_PER_MEASURE * 2); ++i) {
      if (i < n/2) {
        if (slot[i+NOTES_PER_MEASURE*4] == -1) {
          slot[i] = -1;
        } else {
          slot[i] = 0;
          total_notes_in_3rd_thru_6th_measures++;
        }
      }
      else {
        if (slot[i-NOTES_PER_MEASURE*4] == -1) {
          slot[i] = -1;          
        } else {
          slot[i] = 0;
          total_notes_in_3rd_thru_6th_measures++;
        }
      }
      //end if/else
    }
    //end for i
    
    //Mutate some of the rhythms by adding / subtracting rests at random
    int startIndex = NOTES_PER_MEASURE * 2;  //begin at slot index 16 (3rd measure)
    Integer[] indices = new Integer[NOTES_PER_MEASURE * 4];   //store all indices in the 3rd thru 6th measure)
    for (int i = 0, j = startIndex; i < indices.length; ++i, ++j) {
      indices[i] = j;
    }
    List<Integer> indicesAL = Arrays.asList(indices);        //put these indices into a list and shuffle
    Collections.shuffle(indicesAL);
    
    int x = indicesAL.size() / 4;                            //only look at 25% of these shuffled indices as potentially eligible for mutation
    
    //Go thru the first x indices in the shuffled AL and, with 25% chance, turn it into a rest or vice versa.
    for (int i = 0; i < x; ++i) {
      int ind = indicesAL.get(i);
      System.out.printf("slot[%s] = %s\n", ind, slot[ind]);
      Random r = new Random();
      if (r.nextInt(4) == 3) {                 //25% chance this will happen, then mutate
        System.out.printf("Switching slot[%s]...\n", ind);
        if (slot[ind] == -1) {
          slot[ind] = 0;                           //replace rest with a note
          total_notes_in_3rd_thru_6th_measures++;  //also update the number of notes in these measures as needed
        } else {
          slot[ind] = -1;                          //replace note with a rest
          total_notes_in_3rd_thru_6th_measures--;  //also update the number of notes in these measures as needed
        }        
      }
      //end if
    }
    //end for i
    
    System.out.printf("total_notes_in_3rd_thru_6th_measures = %s\n", total_notes_in_3rd_thru_6th_measures);
    
    //Now it's time to generate notes.
    //To give ourselves some wiggle room, we'll use the max between the saved max_interval + 2 and perfect fifth (7 intervals)
    //We will not exceed this max interval when generating adjacent notes.
    max_interval = Math.max(max_interval+2, 7);
    
    //Let's set the min. note and max. note range to be the greater of either:
    //1) ((max note) - (min note)) * 1.5; or
    //2) 12 (an octave).
    //This again gives us some wiggle room. We will not exceed this min. or max. note while generating notes
    int noterange = (int)((maxNote - minNote) * 1.5);
    noterange = Math.max(noterange, 12);
    int diff_range = noterange - (maxNote - minNote);
    System.out.printf("minNote, maxNote: %s (%s) and %s (%s)\nre-computed noterange: %s\ndiff_range: %s\n", minNote, getNoteName(minNote), maxNote, getNoteName(maxNote), noterange, diff_range);
    
    //Let's adjust the min. and max. note according to the new range we computed above.
    minNote = Math.max(0, minNote - (diff_range/2));                   //make sure the min note doesn't fall below 0
    maxNote = Math.min(NUM_SEMITONES - 1, maxNote + (diff_range/2));   //make sure the max note doesn't fall above the max. allowed pitch
    
    System.out.printf("adjusted minNote, maxNote: %s (%s) and %s (%s)\n", minNote, getNoteName(minNote), maxNote, getNoteName(maxNote));
    
    //Let's build a frequency distribution of the various intervals we saved previously, and smooth it out a bit by making
    //the frequency of each interval (within the maximum interval range) at least 1.
    //We will choose at random from freq_dist to help generate the next note with a probability that
    //roughly approximates the frequency of intervals used in the beginning and ending measures.
    ArrayList<Integer> freq_dist = new ArrayList<Integer>();
    for (int i = 0; i <= max_interval; ++i) {
      freq_dist.add(i);
      if (i == 0) continue;  //We'll keep the frequency of interval 0 at at minimum.
      int curr_freq = intervals[i];
      for (int j = 0; j < curr_freq; ++j) {
        freq_dist.add(i);
      }
    }
    
    System.out.printf("intervals: %s\nfreq_dist: %s\n", Arrays.toString(intervals), freq_dist);
    
    //Get the final note in the 2nd measure, so that we can begin building computing adjacent intervals and generating the next note
    int curr_index = NOTES_PER_MEASURE * 2 - 1;
    int prev_note = slot[curr_index];
    while (prev_note == -1) {   //we want the final (non-rest) note. This assumes that there is at least one note in the first 2 measures. Otherwise it'll probably crash.
      prev_note = slot[--curr_index];
    }
    
    System.out.printf("Final note in the 2nd (or 1st) measure: %s (%s)\n", prev_note, getNoteName(prev_note));
    
    //Now we're ready to generate notes for 3rd thru 6th measure.
    System.out.println("Generating notes...");
    int freq_dist_length = freq_dist.size();
    for (int i = NOTES_PER_MEASURE * 2; i < MAX_NUM_OF_NOTES - NOTES_PER_MEASURE * 2; ++i) {
      if (slot[i] == -1) continue;    //leave rests alone.
      //TODO generate a note and replace slot[i] with it.
      int curr_note = -1;
      
      //Invoke custom method generateNote(). There's a nonzero probability that the generated note is illegal (-1), 
      //which is the reason for the while loop
      while (curr_note == -1) {
        int curr_interval = freq_dist.get(new Random().nextInt(freq_dist_length));   //choose an interval at random from the frequency distribution
        System.out.printf("Current interval for i = %s: %s\n", i, curr_interval);
        System.out.printf("prev_note: %s (%s)\n", prev_note, getNoteName(prev_note)); 
        curr_note = generateNote(prev_note, curr_interval, minNote, maxNote, winner[0],
                                 winner[1] == 0 ? major : winner[1] == 1 ? minor_melodic : winner[1] == 2 ? minor_natural : minor_harmonic);
        System.out.printf("curr_note chosen for i = %s: %s (%s)\n", i, curr_note, getNoteName(curr_note));
      }
      slot[i] = curr_note;
      prev_note = curr_note;
    }
    
    
    /* Commented out teacher's barebones solution */
    //for(int i=16; i<n-16; i++) {
       //if(i<n/2) slot[i]=slot[i+32]; // alternate beginning and end
       //else slot[i]=slot[i-32];
  }
  
  /**
   * Method: generateNote
   */
   int generateNote(int prev_note, int curr_interval, int minNote, int maxNote, int tonic, int[] key) {
     int ret = -1;
     Random r = new Random();
     
     //The generated note will be either above or below the prev note, with probability 50%
     int note_lower = prev_note - curr_interval;
     int note_higher = prev_note + curr_interval;
     ArrayList<Integer> contenders = new ArrayList<Integer>();
     contenders.add(note_lower);
     contenders.add(note_higher);
     
     //If either note is out of allowed range, remove it from consideration
     if (note_higher > maxNote) contenders.remove(1);
     if (note_lower < minNote) contenders.remove(0);
     
     System.out.printf("contenders so far: %s\n", contenders);
     
     if (contenders.isEmpty()) return -1;  //If there is no legal note, return -1.
     ret = contenders.get(r.nextInt(contenders.size())); //Choose legal note at random
     System.out.printf("initially chosen ret = %s (%s)\n", ret, getNoteName(ret));
     
     //Now check whether the chosen note appears in the scale as indicated by the given key_signature.
     //We generally want our generated notes to pertain to the key signature, but will allow deviation with some small probability.
     int[] scale = buildScale(tonic, key, NUM_SEMITONES);
     System.out.printf("scale in %s: %s\n", getNoteName(tonic), Arrays.toString(scale));
     if (scale[ret] == 1) return ret; //If the chosen note is contained in the scale, we're all good. Return it immediately
     
     //If we got this far, the chosen note is within allowed range but isn't contained in the scale.
     //90% of the time, let's adjust it up or down to the nearest note that pertains to the scale.
     //10% of the time, let's just use the note  as is (this will likely increase the overall level of dissonance in the song)
     //Update: consider just skipping this part altogether, esp. for tonal music it just seems to add unnecessary noise
     //if (r.nextInt(10) == 0) {
     //  System.out.printf("Returning note %s (%s), which does not pertain to the chosen scale... (happens 10%% of the time)\n", ret, getNoteName(ret));
     //  return ret;  //10% of the time, return the note as is
     //}
     
     //The rest of the time, let's adjust it up or down to the nearest legal note in the scale.
     //Find the nearest legal note above, if it exists
     int ret_upper = ret;
     while (ret_upper < scale.length && scale[ret_upper] != 1) {
       ret_upper++;
     }
     
     //Find the nearest legal note below, if it exists
     int ret_lower = ret;
     while (ret_lower >= 0 && scale[ret_lower] != 1) {
       ret_lower--;
     }
     
     contenders.clear();
     if (ret_upper < scale.length) contenders.add(ret_upper);
     if (ret_lower >= 0) contenders.add(ret_lower);
     if (contenders.isEmpty()) return -1;  //If no legal note, return -1
     
     return contenders.get(r.nextInt(contenders.size()));  //choose note at random and return. 
   }

  /**
   * Method: computeSimilarity
   * @param counter counter of notes
   * @param i the tonic key.
   * @param j if j == 0, it's a major key. Otherwise, minor.
   * @return the similarity score between the counter and the scale as defined by i and j.
   */
  int computeSimilarity(int[] counter, int i, int j) {
    int ret = 0;
    //Heuristic:
    //a) For every time the tonic note is contained in counter, add score of 3.
    //b) For every time the perfect fifth note is contained, add score of 2.
    //c) For every time the major (or minor, depending on j) 3rd note is contained, add score of 1.
    int k = i % 12;   //compute the lowest tonic note, just in case.
    while (k < counter.length) {
      ret += (counter[k] * 3);           //heuristic (a)
      if (k + 7 < counter.length) {      //heuristic (b)
        ret += (counter[k + 7] * 2);
      }
      //heuristic (c)
      if (j == 0) {   //major scale, so we look for major 3rd note
        if (k + 4 < counter.length) ret += (counter[k + 4]);
      } else {        //j > 0, ergo minor scale, ergo we look for minor 3rd note
        if (k + 3 < counter.length) ret += (counter[k + 3]);
      }
      //end if/else
      k += 12;      //increment by an octave
    }
    return ret;
  }
  
  /**
   * Method: computeDiff
   * @param scale a major or minor scale in some given key as tonic
   * @param counter counter of notes
   * @return the number of notes in counter that do NOT pertain to the given scale.
   */
  int computeDiff(int[] scale, int[] counter) {
    int ret = 0;
    for (int i = 0; i < counter.length; ++i) {
      if (counter[i] == 0) continue;
      if (scale[i] == 0) ret += counter[i]; //if counter contains notes that are NOT in the scale, count up the no. of those notes
    }
    return ret;
  }
  
  /**
   * Method: getNoteName
   * @param i an index number
   * @return the name of the note pertaining to i
   */
  String getNoteName(int i) {
    switch(i % 12) {
      case 0: return "A";
      case 1: return "A# / Bb";
      case 2: return "B";
      case 3: return "C";
      case 4: return "C# / Db";
      case 5: return "D";
      case 6: return "D# / Eb";
      case 7: return "E";
      case 8: return "F";
      case 9: return "F# / Gb";
      case 10: return "G";
      default: return "G# / Ab";  //case 11
    }
  }
  
  /**
   * Method: buildScale
   * @param i pertains to the tonic of the scale, where 0 = A, 1 = A#, ..., 11 = G#.
   * @param key semitonic intervals pertaining to either major, minor melodic, minor harmonic, or minor natural scale.
   * @param n the total number of semitones
   * @return an array of notes of size n, pertaining to a scale consistent with the given note and key.
   */
  int[] buildScale(int i, int[] key, int n) {
    //i.e. major key = {2, 2, 1, 2, 2, 2, 1}
    int[] ret = new int[n];
    
    //Start at i and, for each note i that appears in the scale, set ret[i] = 1 for that note.
    int i_copy = i;
    int k = 0;
    while (i_copy < n) {
      ret[i_copy] = 1;
      i_copy += key[k++];
      if (k >= key.length) k = 0;
    }
    
    //Now go backward from i and fill in the beginning parts of the scale for completeness
    i_copy = i;
    k = key.length - 1;
    while (i_copy >= 0) {
      ret[i_copy] = 1;
      i_copy -= key[k--];
      if (k < 0) k = key.length - 1;
    }
    return ret;
  }

  // ********************************************************* EDITING WITH KEYS
  void startRecording(){s=0; recording=true; reset();}
  void recordNote(int myNote) {if(recording && s<n) slot[s++]=myNote;}
  void resumeRecording() {recording=true;}
  void endRecording() {recording=false;}


  // ********************************************************* EDITING WITH MOUSE
  void deleteNote(int when) {slot[when]=-1;}
  void addNote(int when, int note) {if(0<=note && note<26 && 0<=when && when<=n ) slot[when]=note;}
  void toggleSlot(int mx, int my) // BASED ON MOUSE LOCATIONS
    {
    float w = (width-2*lm) / (n), h = (height - 2*tm) / 26;
    int x = int((mx-lm)/w);        // slot
    if(x<0) x=0; if(x>n-1) x=n-1;  // check that valid slot
    int y = int((height-my-tm)/h); // note
    if(0<=y && y<=25)              // check that valid note
      if(slot[x]==y) slot[x]=-1; // if clicked on a note, remove it
      else                     // otherwise add it
        {
        slot[x]=y;
        play(y);
        }
    }


  // ********************************************************* PLAYING
  void startTune() {s=-1; f=0; playing=true;}
  
  void startTune(int mx) 
    {
    float w = (width-2*lm) / (n);
    int x = int((mx-lm)/w);
    if(x<0) x=0; if(x>n-1) x=n-1;
    s=x-1; 
    f=(s+1)*d; 
    playing=true;
    }
    
  void continueTune() 
    {
    float w = (width-2*lm) / (n), h = (height - 2*tm) / 26;
    if(playing) 
      {
      if(f%d==0) 
        {
        s++;            // advance slot counter
        if(slot[s]!=-1) play(slot[s]);  // play note in next slot 
        } 
      if(slot[s]!=-1) 
        {
        stroke(0); strokeWeight(3); noFill();
        ellipse(lm+w*(s+0.5),height-(tm+(slot[s]+0.5)*h),h,h); 
        }
      stroke(100,100,255); strokeWeight(2); line(lm+w*f/d,height-tm,lm+w*f/d,tm);
      text("PLAYING (f="+nf(f,2,0)+"): slot["+s+"]="+nf(slot[s],2,0),10,45);
      f++; // advance frame counter
      if(s>=n-1) playing=false;  
     }
    else {fill(0); text("STOPPED",10,70);}
    }; 

  void play(int note) {pnote=note; playAndShowNote(note); }  
  
   // ********************************************************* DRAWING
  void showSheet() 
    {
    float w = (width-2*lm) / (n), h = (height - 2*tm) / 26;
    stroke(50,50,50); strokeWeight(1);
    fill(0); 
    for(int y=0; y<=25; y++) 
      {
      String N = nf(y,2,0);
      char L = noteName(y);
      text(N+L,5,height-(tm+y*h+8)); 
      }
    noFill();
    if(showStaff)                      // Show 5 black, 3 grey (short), white (between), and yellow (accidentals) rows of staff
      for(int y=0; y<=25; y++) 
        {
        char c = rc[y];
        if(c=='b') fill(20,20,20);
        if(c=='g') fill(150,150,150);
        if(c=='w') fill(250,250,250);
        if(c=='y') fill(250,250,100); 
        rect(lm,height-(tm+(y+1)*h),width-2*lm,h); // horizontal bars
        }  
    else
      for(int y=0; y<=25; y++) 
        {
        if(y%12==2 || y%12==4 || y%12==7 || y%12==9 || y%12==11 ) fill(210,215,225); 
        else fill(250,250,170);  
        rect(lm,height-(tm+(y+1)*h),width-2*lm,h); // horizontal bars
        }  
         
    stroke(50,50,50); strokeWeight(1);
    for(int x=0; x<=n; x++) line(lm+w*x,height-tm,lm+w*x,tm); // draw vertical lines
    for(int y=0; y<=25; y++) line(lm,height-(tm+y*h),width-lm,height-(tm+y*h)); // draw horizontal lines
    strokeWeight(3); 
    for(int y=0; y<=25; y++) if(y%12==1) line(lm,height-(tm+y*h),width-lm,height-(tm+y*h)); // draw horizontal octave lines
    for(int x=0; x<=n; x++) if(x%8==0) line(lm+w*x,height-tm,lm+w*x,tm); // draw vertical bar lines
    
    stroke(200,255,200); strokeWeight(1); // draw the notes as disks
    for(int i=0; i<n; i++) 
      if(slot[i]!=-1) 
        {
        if(i<16 ||i>=3*16) fill(250,0,0); else fill(0,0,250); // fill red of blue (in the middle)
         ellipse(lm+w*(i+0.5),height-(tm+(slot[i]+0.5)*h),h,h); 
        }
    stroke(0,250,0); strokeWeight(3); noFill(); // draw green line through all notes
    beginShape();
    for(int i=0; i<n; i++) 
      if(slot[i]!=-1) 
        {
        vertex(lm+w*(i+0.5),height-(tm+(slot[i]+0.5)*h)); 
        }
    endShape();
    }
    
   // ********************************************************* CONVERT TO AND FROM STRING
  void printNotes() {println("TUNE:"); for(int i=0; i<n; i++) print(nf(slot[i],2,0)+","); println();}

  String convertToString() 
    {
    String S = "";
    for(int i=0; i<n; i++) S=S+nf(slot[i],2)+",";
    return S;
    }
    
  void ConstructFromString(String S) 
    {
    String[] L = split(S,',');
    for(int i=0; i<n; i++) slot[i]=int(L[i]);
    }
 
  } // END OF CLASS
  


int numNotes = 26;
AudioSample[] sounds = new AudioSample[numNotes];
int audioBuffer = 128;

void loadFiles()
{
  for(int i = 0; i < numNotes; i++)
  {
    String soundFile = "Notes/PianoNote"+nf(i,2,0)+".mp3";
    sounds[i] = minim.loadSample(soundFile, audioBuffer);
  }
}
  
  
char noteName(int p) // note name from pitch
  {
  if(p%12==1) return 'C';
  if(p%12==3) return 'D';
  if(p%12==5) return 'E';
  if(p%12==6) return 'F';
  if(p%12==8) return 'G';
  if(p%12==10) return 'A';
  if(p%12==0) return 'B';
   return ' ';
  }

// row colors In Staff (altered by '#' and 'b')  
char [] rc = {'w','g','y','w','y','b','w','y','b','y','w','y','b','w','y','b','y','w','b','y','w','y','g','y','w','g'};

int tonic = 1;
int sharpCount=0;

void addSharp() 
  {
  for(int i=0; i<23; i++) if(i%12 == (tonic+5)%12) { char c = rc[i]; rc[i]=rc[i+1]; rc[i+1]=c;} 
  rc[24]=rc[0]; rc[25]=rc[1];
  tonic = (tonic+7)%12;
  sharpCount++;
  }
  
void resetSharp() 
  {
  char [] orc = {'w','g','y','w','y','b','w','y','b','y','w','y','b','w','y','b','y','w','b','y','w','y','g','y','w','g'}; 
  for(int i=0; i<26; i++) rc[i]=orc[i];
  sharpCount=0;
  tonic = 1;
  }  
  
  
// ********************************************************* PLAY NOTES WHEN KEYS PRESSED (NOT ON SCORE)
void playAndShowNote(int thisNote)
  {
  pnote=note; 
  note=thisNote;
  playNote(thisNote);
  }

void playNote(int thisNote)
  {
    if (sounds[0] == null) {
      loadFiles();
    }
  sounds[thisNote].trigger();  
  
  //String soundFile = "Notes/PianoNote"+nf(thisNote,2,0)+".mp3";
  //sound = minim.loadFile(soundFile);
  //sound.play();
  //sound.rewind();
  } 
   