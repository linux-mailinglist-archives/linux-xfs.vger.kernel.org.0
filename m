Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 853667875D
	for <lists+linux-xfs@lfdr.de>; Mon, 29 Jul 2019 10:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727514AbfG2I2u (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 29 Jul 2019 04:28:50 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:38291 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726305AbfG2I2u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Jul 2019 04:28:50 -0400
Received: by mail-pg1-f194.google.com with SMTP id f5so19044972pgu.5
        for <linux-xfs@vger.kernel.org>; Mon, 29 Jul 2019 01:28:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0ExKlA3DZz4+IGDf5b2lRWN5RHKh8PsDvjZM7lEEtec=;
        b=kZcOX0mQOXYBNR505taQSrXmT63KZLkPEuV5WdrlswHv290JZRi+CkI+jzRpxKt5ba
         GxvPEg1CsRAdz1JmXdZ2yRT+rjjdq418uzfmRah/N+OG4mAP0SBsDswP4TpbS3jOX1c6
         kQAP4hrV3KM69zzm8QJQdM2cBz3GtOXYOpytYIB0NM9OqfbQDewytdiwdKZ0jJZiRCIJ
         0IkD2CRXEJqKzkoR7HwccYUwvq34YNlyUWYZtsLM/54AEmSu4jwI0qhgh6jqzMxu4wEV
         sgeuwIoGtiQZyEUOlS5TMVDVRhlKx/iy1uFSIDQcxexq8GCP9rI8DQpE82Eoy5ndoOV9
         j7PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0ExKlA3DZz4+IGDf5b2lRWN5RHKh8PsDvjZM7lEEtec=;
        b=UJcgdqCiFJCdJRLW9uijyXdw7FUvjQh9vItKz6orKFkHsLN0EQU1Y6k/P+y0GDHm3G
         wQnvtW6n/W/EcOMcvr7sl4r6KRIp35q9SUPeO1e+dIvEl7XC1qetu0wT+7agphQ5K9uB
         2y0XfURKJdCRzJSFa8+fudSAofNygbhmlGzi2xyJ0lxZLzDy+JhYQt6Rng/Xh5Cp5eyD
         mGH53V5CDf9y4I7xm1eQA+ScMvUGhzmz3ig03n9XsUysNAAV4P9gQxHvzxN0XcCYQygU
         /GL3bbz9LF5IHgtqOTWsP9M4stSLe7nImaaTHMJPR0w/M06Zw83UDmt0Q7oRbUsNCTLN
         B+1w==
X-Gm-Message-State: APjAAAWe1EjeIs+UsAEcZorqLzdZYX00tGDaGtrjk55q5RD1D/gXHu6c
        eB8IPj8HyCjguUzNQWNE2H2aa809
X-Google-Smtp-Source: APXvYqzcCQ6uB5LeeFJTbNT6BeUA//64cSoWjGZktP6RSUF1t6Z5h+z+izLggQe1wrwVvbp/Vpftzw==
X-Received: by 2002:a62:35c6:: with SMTP id c189mr35313470pfa.96.1564388929587;
        Mon, 29 Jul 2019 01:28:49 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w14sm68644212pfn.47.2019.07.29.01.28.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jul 2019 01:28:49 -0700 (PDT)
Date:   Mon, 29 Jul 2019 16:28:41 +0800
From:   Murphy Zhou <jencce.kernel@gmail.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Murphy Zhou <jencce.kernel@gmail.com>, linux-xfs@vger.kernel.org,
        linux-nvdimm@lists.01.org
Subject: Re: xfs quota test xfs/050 fails with dax mount option and "-d
 su=2m,sw=1" mkfs option
Message-ID: <20190729082841.6uiroqyygnb3ngls@XZHOUW.usersys.redhat.com>
References: <20190724094317.4yjm4smk2z47cwmv@XZHOUW.usersys.redhat.com>
 <20190729001308.GX7689@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190729001308.GX7689@dread.disaster.area>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 29, 2019 at 10:13:08AM +1000, Dave Chinner wrote:
> On Wed, Jul 24, 2019 at 05:43:17PM +0800, Murphy Zhou wrote:
> > Hi,
> > 
> > As subject.
> > 
> > -d su=2m,sw=1     && -o dax  fail
> > -d su=2m,sw=1     && NO dax  pass
> > no su mkfs option && -o dax  pass
> > no su mkfs option && NO dax  pass
> > 
> > On latest Linus tree. Reproduce every time.
> > 
> > Testing on older kernels are going on to see if it's a regression.
> > 
> > Is this failure expected ?
> 
> I'm not sure it's actually a failure at all. DAX does not do delayed
> allocation, so if the write is aligned to sunit and at EOF it will
> round the allocation up to a full stripe unit. IOWs, for this test
> once the file size gets beyond sunit on DAX, writes will allocate in
> sunit chunks.
> 
> And, well, xfs/050 has checks in it for extent size hints, and
> notruns if:
> 
>         [ $extsize -ge 512000 ] && \
>                 _notrun "Extent size hint is too large ($extsize bytes)"
> 
> Because EDQUOT occurs when:
> 
> >     + URK 99: 2097152 is out of range! [3481600,4096000]
> 
> the file has less than 3.5MB or > 4MB allocated to it, and for a
> stripe unit of > 512k, EDQUOT will occur at  <3.5MB. That's what
> we are seeing here - a 2MB allocation at offset 2MB is > 4096000
> bytes, and so it gets EDQUOT at that point....
> 
> IOWs, this looks like a test problem, not a code failure...

Got it. Thanks Dave!

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
