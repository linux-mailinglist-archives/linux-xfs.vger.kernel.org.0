Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35FDD2023DA
	for <lists+linux-xfs@lfdr.de>; Sat, 20 Jun 2020 14:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728134AbgFTMy0 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 20 Jun 2020 08:54:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728103AbgFTMy0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 20 Jun 2020 08:54:26 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 463E5C06174E
        for <linux-xfs@vger.kernel.org>; Sat, 20 Jun 2020 05:54:26 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id s14so1129503plq.6
        for <linux-xfs@vger.kernel.org>; Sat, 20 Jun 2020 05:54:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/rmyxgfQh3D4ziSunvxwMKAFbCRqFHaJA6hItOTgr1s=;
        b=RZKVrkn5VeLnJhk0gc2OcG3M/pYLShd4GMmkSOxaaq27XlEXy+BROH9p/+b92ludYR
         7/6JYQo6pxoq5bquz+UCtdSPi3mlQj5MuQmLSFaEq5ytGv/rpbbE+BJ4KgiJ30pIbehH
         hcUyscwI8z7CD/zaQ0u6HjheIF4Vd0jNpfhdFEWWYMrcXNf0E4hV5twbrsssS8+etB3x
         vVvqYYLxzkIu50H79D8vK2MiWyHN2a7ee/qT2TL0gz/jOqKj17ZYpWHQyX7x1rqfUAaA
         9MQXnoKBh+Yy6+GTX/qw6M9mMlzZXaUIGSUPPbkbRsg5Xf+VbehYbL6EUJatCegiE/QO
         RB5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/rmyxgfQh3D4ziSunvxwMKAFbCRqFHaJA6hItOTgr1s=;
        b=EuhxJ3icA3m+5JZkOxACLz9AiYIkg/7RGBLIXSIFSpIfAXveEOamv7ZHV4C5rMS6wX
         k8ufjIGa+B7D2nn3MRqiEKtIm1h6fYy44jGtd3Cmjrh3ooGw43bXb85tfUH7NhfiK/VD
         r36oBvldRM+C0YZlePQuspEEgWv5F7gZ9KjDyvH/MSrk+QcCXpUbtozrosMP7/Wp/5DY
         ieLTW4vk38HzTcA3nC60N6SUtWJOdMAn5CDyxt3bPj87sHZLeDm/V7ATFCbmsqgRYAaN
         S3sAK2XM/NwzQ8K+VMEYiNqnf8jfYmep05wEF68eJR7v9c7Wrp4eEVpMGahzgE74Gy2Y
         uRCg==
X-Gm-Message-State: AOAM530U65FhT09LXgzlxGj5F/gbETCVqk1fx+ZymeXWyjZce3kckYdx
        RHaJeRb1dL3Bt57n924c1m4=
X-Google-Smtp-Source: ABdhPJwzEGGV9DHwpXXqdOvCv/BYLrVXvPa6qDBg+h7gfB7IHcP36oKqpwvbdAePcYhDs2TTrR/2XQ==
X-Received: by 2002:a17:90a:8a8e:: with SMTP id x14mr7840708pjn.169.1592657665898;
        Sat, 20 Jun 2020 05:54:25 -0700 (PDT)
Received: from garuda.localnet ([171.61.66.69])
        by smtp.gmail.com with ESMTPSA id a19sm8698605pfd.165.2020.06.20.05.54.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Jun 2020 05:54:25 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        darrick.wong@oracle.com, bfoster@redhat.com
Subject: Re: [PATCH 6/7] xfs: Extend data extent counter to 47 bits
Date:   Sat, 20 Jun 2020 18:22:38 +0530
Message-ID: <2344093.5IAYvqKUa4@garuda>
In-Reply-To: <20200619143846.GC29528@infradead.org>
References: <20200606082745.15174-1-chandanrlinux@gmail.com> <20200606082745.15174-7-chandanrlinux@gmail.com> <20200619143846.GC29528@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Friday 19 June 2020 8:08:46 PM IST Christoph Hellwig wrote:
> On Sat, Jun 06, 2020 at 01:57:44PM +0530, Chandan Babu R wrote:
> > This commit extends the per-inode data extent counter to 47 bits. The
> > length of 47-bits was chosen because,
> > Maximum file size = 2^63.
> > Maximum extent count when using 64k block size = 2^63 / 2^16 = 2^47.
> 
> What is the use case for a large nuber of extents?  I'm not sure why
> we'd want to bother, but if there is a good reason it really should
> be documented here.
> 
> 

Late last year, Dave had pointed me to the commit "xfs: fix inode fork extent
count overflow" (3f8a4f1d876d3e3e49e50b0396eaffcc4ba71b08) where the following
scenario is described,

Fallocate 40TiB of disk space and then alternatively punch out fs
blocks. Assuming 4k block size, this would give,

40TiB / 4k / 2 = ~5 billion extents.

This won't fit into a unsigned 32-bit field which can hold a maximum value of
~4 billion.

Dave mentioned that we will go over the 32-bit extent counter limit
soon. Hence this patch extends the on-disk data fork extent counter to a
64-bit field.

In my next version of this patchset, I will add the technical part of the
above description to the patch. Sorry for missing that out.

-- 
chandan



