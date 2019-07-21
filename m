Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9B756F42D
	for <lists+linux-xfs@lfdr.de>; Sun, 21 Jul 2019 18:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726709AbfGUQns (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 21 Jul 2019 12:43:48 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:43226 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726323AbfGUQns (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 21 Jul 2019 12:43:48 -0400
Received: by mail-pl1-f195.google.com with SMTP id 4so10996294pld.10;
        Sun, 21 Jul 2019 09:43:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=aQv+d6mvKk/q+K+x1AZ5av9JIxC1+jRJxjkGus2ZK4c=;
        b=pvkN6z+i8nFOrrfRx+CbMtyItTXuqgUvG4gFnh9DQypH/d6OtwF1bLkYztX0+YIhYZ
         L8rdtz2RDyVdR7XjZM7RYs7+mC/CV/hVXcOCzCj7KI9wIrULC3FT/qQqi4rffWH81yMj
         /J/vcWD20pBf+z76itEEWALyc/EZ6PR/fbCl/6gdM1hG3/T9g0Hi4H0BdzMpJ+E7APbb
         CGIHMiHdxBCeGtN0mpUxAR/2BdvrUjxU04qVEhvAB+Y73Riiza1uGelfWfnK9Zcmy0zm
         NVaxFHoLkmathTlPUg/Wi7Ul22uQHR0pANjX0q6Ety2cTVN2sxsSVqidZSWf4di3fy7d
         IKLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=aQv+d6mvKk/q+K+x1AZ5av9JIxC1+jRJxjkGus2ZK4c=;
        b=b+oPj76jM9JE/5Ge6UmcooQeS0Kcjv7G71abXxLaOSYTjHPg63scKsvP4vp3aRMOHn
         F9LlRqUn2vLGxfGyKM0sF2dB8TQ3PBPDXx5Tm+6Bk14mBG+U3/T8Ju1AIn7i5Bf3bWhX
         OntVb+CBHwIyQsg6qg+NkkX2kqjsHvBYWpimFqdzuTZMgI2u2uilrB5tqf3zxpyhULSa
         2UKpvVRKC8gBF/Hz2AAejkdOnIThFoGNHWJrlo00subY8IH9YAI2SZvXkluFZE+xBPMB
         cOpe/RF0LPtlN8fAlrZyK+VfV6qqhR+OiqrZKwVYS1qBzt1eKVwBzt7KmX2bu3yTTiri
         TOag==
X-Gm-Message-State: APjAAAUzvwvzNAztOhdQjv8ZQvzuiaksXhV+3RHqqKKTjn1Td0zgDtdD
        q0FsM1EOKYU5j5iL9Ym8ugE=
X-Google-Smtp-Source: APXvYqygMsz131j3S9kdBRU/DCtAJ9knJSEtob6O2EaUmoH1rljuJLkkQ0ovag9FqXiqWB7n7GsfyQ==
X-Received: by 2002:a17:902:549:: with SMTP id 67mr70467321plf.86.1563727427870;
        Sun, 21 Jul 2019 09:43:47 -0700 (PDT)
Received: from localhost ([178.128.102.47])
        by smtp.gmail.com with ESMTPSA id p7sm38818538pfp.131.2019.07.21.09.43.45
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 21 Jul 2019 09:43:46 -0700 (PDT)
Date:   Mon, 22 Jul 2019 00:43:38 +0800
From:   Eryu Guan <guaneryu@gmail.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Olga Kornievskaia <olga.kornievskaia@gmail.com>,
        fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH v4 2/3] generic: copy_file_range bounds test
Message-ID: <20190721164338.GJ7943@desktop>
References: <20190715125516.7367-1-amir73il@gmail.com>
 <20190715125516.7367-3-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190715125516.7367-3-amir73il@gmail.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 15, 2019 at 03:55:15PM +0300, Amir Goldstein wrote:
> Test that copy_file_range will return the correct errors for various
> error conditions and boundary constraints.
> 
> This is a regression test for kernel commit:
> 
>   5dae222a5ff0 vfs: allow copy_file_range to copy across devices

This seems like refering to the wrong commit, I've changed it to

96e6e8f4a68d ("vfs: add missing checks to copy_file_range")

Thanks,
Eryu
