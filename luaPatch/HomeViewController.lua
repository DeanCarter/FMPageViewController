

waxClass{"HomeViewController", UIViewController}


function homeItemViewAction(self, itemView)
    local num = itemView:item():tag()
    puts(num)

    if (num == 1000) then
         self:adsJump()
    else if (num == 1200) then
         self:mainPageController():goModule(MainTypeHotel)
    end

end