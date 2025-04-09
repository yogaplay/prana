package com.prana.backend;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/share")
public class TemplateController {

    private static final String prefix = "https://prana-yoplay.s3.ap-northeast-2.amazonaws.com/share/";

    @GetMapping("/{request}")
    public String showPreview(@PathVariable String request, Model model) {
        model.addAttribute("imageUrl", prefix + request);
        model.addAttribute("appDownloadUrl", "market://details?id=com.example.frontend");
        return "image-display";
    }

}
