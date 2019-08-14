Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 712C58D1AB
	for <lists+linux-xfs@lfdr.de>; Wed, 14 Aug 2019 13:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726525AbfHNLBz (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 14 Aug 2019 07:01:55 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43694 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726263AbfHNLBz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Aug 2019 07:01:55 -0400
Received: by mail-wr1-f66.google.com with SMTP id y8so4723455wrn.10
        for <linux-xfs@vger.kernel.org>; Wed, 14 Aug 2019 04:01:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=NGRYaPZ45BRZWNIa21aeYiY76Szc1jOCs/Op2S6T54w=;
        b=IarHfeiJGxVHuAatUIoLAB95Sj5TluiKHQP5ZVy2z7WEnbgF/ItZGXqnR9dywfCK9q
         V4PuojF8kWW/1cr1PTwQrkDuNtpvKV4eIcXAzqFEpgvh+jU2bOaCF9siU9b+Q92iD0Y2
         EqZaLsOcADiNrDwXUCH/Odvlz8hOoHweh2OttsyHDXS0thqOSktbk/KpFRI6V4i3PUyI
         psz18KwL3VQ3NZ9c77yr1GxknR7VQLDLbcpH50jEEZGmFd3iXDY44zDcdjZY3trFINdq
         etLKrSyetomnZswzLE6bZfuoVaztWGrwwQYH9e5Q8uijHnoxHZG5gnCIvHvfsNwPXO6V
         Y4EQ==
X-Gm-Message-State: APjAAAWx61tv3Kukv49vRyBrMIDxcTgowgFplEz6V+4i9z4ZybNImRoN
        h0IYCWbd+FcMOubiwDCKXnmzew==
X-Google-Smtp-Source: APXvYqx2o/5vbO1C2Mh54gC+k3S2ckhjY8e8pBqQSKe0tOSeU5eloxorZnGqPyT3xI0D2V+LtM7MlQ==
X-Received: by 2002:adf:fd82:: with SMTP id d2mr40395664wrr.194.1565780513363;
        Wed, 14 Aug 2019 04:01:53 -0700 (PDT)
Received: from pegasus.maiolino.io (ip-89-103-126-188.net.upcbroadband.cz. [89.103.126.188])
        by smtp.gmail.com with ESMTPSA id h2sm3048853wmb.28.2019.08.14.04.01.52
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 14 Aug 2019 04:01:52 -0700 (PDT)
Date:   Wed, 14 Aug 2019 13:01:50 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     linux-fsdevel@vger.kernel.org
Cc:     hch@lst.de, adilger@dilger.ca, jaegeuk@kernel.org,
        darrick.wong@oracle.com, miklos@szeredi.hu, rpeterso@redhat.com,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/9] fibmap: Use bmap instead of ->bmap method in
 ioctl_fibmap
Message-ID: <20190814110148.kbp6tplxibrnfpej@pegasus.maiolino.io>
Mail-Followup-To: linux-fsdevel@vger.kernel.org, hch@lst.de,
        adilger@dilger.ca, jaegeuk@kernel.org, darrick.wong@oracle.com,
        miklos@szeredi.hu, rpeterso@redhat.com, linux-xfs@vger.kernel.org
References: <20190808082744.31405-5-cmaiolino@redhat.com>
 <201908090430.yoyXYjeY%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201908090430.yoyXYjeY%lkp@intel.com>
User-Agent: NeoMutt/20180716
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hey folks,

> All errors (new ones prefixed by >>):
> 
>    fs/ioctl.c: In function 'ioctl_fibmap':
> >> fs/ioctl.c:68:10: error: implicit declaration of function 'bmap'; did you mean 'kmap'? [-Werror=implicit-function-declaration]

Any of you guys may have a better idea on how to fix this?

Essentially, this happens when CONFIG_BLOCK is not set, and although I don't
really see a hard requirement to have bmap() exported only when CONFIG_BLOCK is
set, at the same time, I don't see use for bmap() if CONFIG_BLOCK is not set.

So, I'm in a kind of a chicken-egg problem.

I am considering to just remove the #ifdef CONFIG_BLOCK / #endif from the bmap()
declaration. This will fix the warning, and I don't see any side effects. What
you guys think?


>      error = bmap(inode, &block);
>              ^~~~
>              kmap
>    cc1: some warnings being treated as errors
> 
> vim +68 fs/ioctl.c
> 
>     53	
>     54	static int ioctl_fibmap(struct file *filp, int __user *p)
>     55	{
>     56		struct inode *inode = file_inode(filp);
>     57		int error, ur_block;
>     58		sector_t block;
>     59	
>     60		if (!capable(CAP_SYS_RAWIO))
>     61			return -EPERM;
>     62	
>     63		error = get_user(ur_block, p);
>     64		if (error)
>     65			return error;
>     66	
>     67		block = ur_block;
>   > 68		error = bmap(inode, &block);
>     69	
>     70		if (error)
>     71			ur_block = 0;
>     72		else
>     73			ur_block = block;
>     74	
>     75		error = put_user(ur_block, p);
>     76	
>     77		return error;
>     78	}
>     79	
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation



-- 
Carlos
