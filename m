Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6D6777F40
	for <lists+linux-xfs@lfdr.de>; Sun, 28 Jul 2019 13:30:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726004AbfG1Lan (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 28 Jul 2019 07:30:43 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:38865 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726001AbfG1Lam (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 28 Jul 2019 07:30:42 -0400
Received: by mail-pg1-f193.google.com with SMTP id f5so18009167pgu.5;
        Sun, 28 Jul 2019 04:30:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=PJc6ywPN6Vjrb4lCSSsUYcEukgYPnGNwtgYI4MVtIMQ=;
        b=BcynL9OoA6G2NPMlfwrUKyj5tFDzJW++3URT4mkKxw/338Y51xNMtZY7LBx1xV4Wps
         pOLKcnzqtg7h5g6XgL/sj1L4Q0priV7EDDL5swjhQMQfOtcGYCrgtl8XzY4WwuvjAFWl
         H9Jnqz6C0T/BK2nmvmIgHepgqawpKen8kZPDoQqJ3xcpZnLxOyNowypzxahz2/OKI8/F
         v5tgPI2xvCLtj1pFpVP7WU/dskpSw0GMgHUc4k3HWzCucRzqCU4UBJd3VBvWFN5SR1Dj
         gAF8jgl6wVW+b1HooIKgAdc6xrO8Kk/1pfaXnA4iOfmU/39SFYCNnEL8/6DuJ/wnbys8
         UQ2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=PJc6ywPN6Vjrb4lCSSsUYcEukgYPnGNwtgYI4MVtIMQ=;
        b=Gtyg1QBhW373bwgtcR1OpH2ckZ/i3OhcdYACAFIhkUlQP/u7xBgCveyPdMGasTYUEH
         d1YquEqJiMPjfn+P07ej9DFGuyyOkvHTrzcFDavxKId3tMeWAACFgLsJ9wwHOC5cu5Xx
         bkH1diXmvJ0FTGgEbJ+MhvDUMZOXXuMXvF37wXtmeZjgY/cm5DPxdudGmkZoTWHDT0cw
         7R/+bYirWo2Fa/63Q/QggScY+WxGOfddYCXkVsGTtgJvw708e6PcQ+h+CkU5dZA9So62
         2IvD8/bb1KZzY0oq8w5XEpTkjcwkCYmc1/MBiTuPO/nfB8Jo1eoe1guiQeA5ftDJoo22
         hU6Q==
X-Gm-Message-State: APjAAAWRLEPrA7Kna+QpSJNLRNWEaZcCGJoGqApmDG+qfUB7u5cg5sgX
        lg518BMhTBE27mMdFYtUuI4=
X-Google-Smtp-Source: APXvYqwxJvep3ov9i4Zma2QMeYF7JmDYtYBjw4PGzO0za6KebsTFYsCYG/DIRkrl9Hb1Jg7wAXCfMw==
X-Received: by 2002:a63:ee04:: with SMTP id e4mr74582940pgi.53.1564313441899;
        Sun, 28 Jul 2019 04:30:41 -0700 (PDT)
Received: from localhost ([178.128.102.47])
        by smtp.gmail.com with ESMTPSA id 97sm54176362pjz.12.2019.07.28.04.30.40
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 28 Jul 2019 04:30:40 -0700 (PDT)
Date:   Sun, 28 Jul 2019 19:30:36 +0800
From:   Eryu Guan <guaneryu@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH v2 1/3] common: filter aiodio dmesg after fs/iomap.c to
 fs/iomap/ move
Message-ID: <20190728113036.GO7943@desktop>
References: <156394156831.1850719.2997473679130010771.stgit@magnolia>
 <156394157450.1850719.464315342783936237.stgit@magnolia>
 <20190725180330.GH1561054@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190725180330.GH1561054@magnolia>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 25, 2019 at 11:03:30AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Since the iomap code are moving to fs/iomap/ we have to add new entries
> to the aiodio dmesg filter to reflect this.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v2: fix all the iomap regexes
> ---
>  common/filter |    9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/common/filter b/common/filter
> index ed082d24..2e32ab10 100644
> --- a/common/filter
> +++ b/common/filter
> @@ -550,10 +550,10 @@ _filter_aiodio_dmesg()
>  	local warn2="WARNING:.*fs/xfs/xfs_file\.c:.*xfs_file_dio_aio_read.*"
>  	local warn3="WARNING:.*fs/xfs/xfs_file\.c:.*xfs_file_read_iter.*"
>  	local warn4="WARNING:.*fs/xfs/xfs_file\.c:.*xfs_file_aio_read.*"
> -	local warn5="WARNING:.*fs/iomap\.c:.*iomap_dio_rw.*"
> +	local warn5="WARNING:.*fs/iomap.*:.*iomap_dio_rw.*"
>  	local warn6="WARNING:.*fs/xfs/xfs_aops\.c:.*__xfs_get_blocks.*"
> -	local warn7="WARNING:.*fs/iomap\.c:.*iomap_dio_actor.*"
> -	local warn8="WARNING:.*fs/iomap\.c:.*iomap_dio_complete.*"
> +	local warn7="WARNING:.*fs/iomap.*:.*iomap_dio_actor.*"
> +	local warn8="WARNING:.*fs/iomap.*:.*iomap_dio_complete.*"

I don't think we need new filters anymore, as commit 5a9d929d6e13
("iomap: report collisions between directio and buffered writes to
userspace") replaced the WARN_ON with a pr_crit(). These filters are
there only for old kernels.

Thanks,
Eryu

>  	local warn9="WARNING:.*fs/direct-io\.c:.*dio_complete.*"
>  	sed -e "s#$warn1#Intentional warnings in xfs_file_dio_aio_write#" \
>  	    -e "s#$warn2#Intentional warnings in xfs_file_dio_aio_read#" \
> @@ -563,7 +563,8 @@ _filter_aiodio_dmesg()
>  	    -e "s#$warn6#Intentional warnings in __xfs_get_blocks#" \
>  	    -e "s#$warn7#Intentional warnings in iomap_dio_actor#" \
>  	    -e "s#$warn8#Intentional warnings in iomap_dio_complete#" \
> -	    -e "s#$warn9#Intentional warnings in dio_complete#"
> +	    -e "s#$warn9#Intentional warnings in dio_complete#" \
> +	    -e "s#$warn10#Intentional warnings in iomap_dio_actor#"
>  }
>  
>  # We generate assert related WARNINGs on purpose and make sure test doesn't fail
