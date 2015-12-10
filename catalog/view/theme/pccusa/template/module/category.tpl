
  <div class="big-title" style="margin-top: 0px; margin-bottom:30px;">
  <h3> <?php echo $heading_title; ?></h3>
  </div>
  
   <!--Custom Search-->
  <div class="panel panel-default">
    <div class="panel-heading">
      <h3 class="panel-title2 pull-left">Features </h3>
      <div class="clear"><a href="#">Clear</a></div>
    </div>
  <div class="panel-body padd00">
   
    <!-- Collapse-->
    <div class="panel-group marpaddbtm0" id="accordion">
        <!--1-->
        <div class="panel panel-white">
            <div class="panel-heading">
                <h4 class="panel-title3"><a data-toggle="collapse" data-parent="#toggle" href="#collapse-3" class="actives"> Category</a></h4>
            </div>
            <div id="collapse-3" class="panel-collapse collapse in">
                <div class="panel-body">
                
                   
                    <div class="listingP">
                    
                      <div class="checkbox">
                          <input id="check1" type="checkbox" name="check" value="check1">
                          <label for="check1">diamond-bangles <span>230</span></label>
                      </div>
                      
                       <?php foreach ($categories as $category) { ?>
                         <div class="checkbox">
                         <label for="check1">
                            <?php if ($category['category_id'] == $category_id) { ?>
                            <a href="<?php echo $category['href']; ?>" class="active"><?php echo $category['name']; ?></a>
                            <?php } else { ?>
                            <a href="<?php echo $category['href']; ?>"><?php echo $category['name']; ?></a>
                            <?php } ?>
                            <?php if ($category['children']) { ?>
                            <ul>
                              <?php foreach ($category['children'] as $child) { ?>
                              <li>
                                <?php if ($child['category_id'] == $child_id) { ?>
                                <a href="<?php echo $child['href']; ?>" class="active"> - <?php echo $child['name']; ?></a>
                                <?php } else { ?>
                                <a href="<?php echo $child['href']; ?>"> - <?php echo $child['name']; ?></a>
                                <?php } ?>
                              </li>
                              <?php } ?>
                            </ul>
                            <?php } ?>
                            </label>
                          </div>
                        <?php } ?>
                      
                      
                    </div>
                    
                </div>
            </div>
        </div>
        <!--2-->
        <div class="panel panel-white">
            <div class="panel-heading ">
                <h4 class="panel-title3"><a data-toggle="collapse" data-parent="#toggle" href="#collapse-4" class="collapsed"> Price</a></h4>
            </div>
            <div id="collapse-4" class="panel-collapse collapse">
                <div class="panel-body">
                
                    <form>
                    <div class="listingP">
                    
                      <div class="checkbox">
                          <input id="check2a" type="checkbox" name="check" value="check2a">
                          <label for="check2a">2,000 and Below <span>240</span></label>
                      </div>
                      <div class="checkbox">
                            <input id="check1a" type="checkbox" name="check" value="check1a">
                            <label for="check1a">2,001 - 5,000 <span>120</span></label>
                      </div>
                      <div class="checkbox">
                          <input id="check3a" type="checkbox" name="check" value="check3a">
                          <label for="check3a">5,001 - 10,000 <span>98</span></label>
                      </div>
                      <div class="checkbox">
                            <input id="check4a" type="checkbox" name="check" value="check4a">
                            <label for="check4a">10,001 - 20,000 <span>70</span></label>
                      </div>
                      <div class="checkbox">
                          <input id="check5a" type="checkbox" name="check" value="check5a">
                          <label for="check5a">20,001 - 30,000 <span>60</span></label>
                      </div>
                      <div class="checkbox">
                          <input id="check6a" type="checkbox" name="check" value="check6a">
                          <label for="check6a">30,001 and Above <span>50</span></label>
                      </div>
                      
                    </div></form>
                    
                </div>
            </div>
        </div>
        <!--3-->
        <div class="panel panel-white">
            <div class="panel-heading ">
                <h4 class="panel-title3"><a data-toggle="collapse" data-parent="#toggle" href="#collapse-5" class="collapsed"> Discount %</a></h4>
            </div>
            <div id="collapse-5" class="panel-collapse collapse">
                <div class="panel-body">
                
                    <form>
                    <div class="listingP">
                    
                      <div class="checkbox">
                          <input id="check1b" type="checkbox" name="check" value="check1b">
                          <label for="check1b">0 - 10% <span>50</span></label>
                      </div>
                      <div class="checkbox">
                          <input id="check2b" type="checkbox" name="check" value="check2b">
                          <label for="check2b">10 - 20% <span>10</span></label>
                      </div>
                      <div class="checkbox">
                          <input id="check3b" type="checkbox" name="check" value="check3b">
                          <label for="check3b">20 - 30% <span>80</span></label>
                      </div>
                      <div class="checkbox">
                          <input id="check4b" type="checkbox" name="check" value="check4b">
                          <label for="check4b">30 - 40% <span>70</span></label>
                      </div>
                      <div class="checkbox">
                          <input id="check5b" type="checkbox" name="check" value="check5b">
                          <label for="check5b">40 - 50% <span>60</span></label>
                      </div>
                      <div class="checkbox">
                          <input id="check6b" type="checkbox" name="check" value="check6b">
                          <label for="check6b">50 - 60% <span>50</span></label>
                      </div>
                      <div class="checkbox">
                          <input id="check7b" type="checkbox" name="check" value="check7b">
                          <label for="check7b">60 - 70% <span>40</span></label>
                      </div>
                      
                    </div></form>
                    
                </div>
            </div>
        </div>
        <!--4-->
    </div>

  </div>
  </div>