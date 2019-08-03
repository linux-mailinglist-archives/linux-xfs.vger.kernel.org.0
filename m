Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 496F180529
	for <lists+linux-xfs@lfdr.de>; Sat,  3 Aug 2019 10:05:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387533AbfHCIFW (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 3 Aug 2019 04:05:22 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:35813 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387429AbfHCIFW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 3 Aug 2019 04:05:22 -0400
Received: by mail-qt1-f196.google.com with SMTP id d23so76389752qto.2
        for <linux-xfs@vger.kernel.org>; Sat, 03 Aug 2019 01:05:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=VS91CNpqi+YsESJrk6e72B5yafz/V3LEjSoCuKf0/fE=;
        b=IBPsFs+0VC6vzz7lVfBZ+3jmGmnwRe2gLytQfQpE8mS5f1RMwQkoO1QruxIbEks+0D
         O9vpmH66Vrqs/hLvUlsbFhgiYii5bsu9BjIkB7i+wUnXpN3GJ3Nh96dU82iUYaWXLhra
         hJv5XEEd4qDooScRDp8Z5VulxYhzLaJz+DYE9G0mmY4+o09g0ruft0AjkLkMen/duESY
         nXtxI/pjWSqjfaKi7nLUnvKfZKNhOq6Ck09DpR1MAwYRX+aSdLUVYccBMqvzck2UNNMA
         7cp+81WiZmtaXcXQi1wdbuxPtSLn1ZGOzeFA1ytFftgo2g0laENp47oFyJ5AyFo6kDah
         dVPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VS91CNpqi+YsESJrk6e72B5yafz/V3LEjSoCuKf0/fE=;
        b=OeD4+JJm99N4R4rkmi6/K+sxgJ/rhUL/dOWvl0efsUAMQLc9xBLEp3c8aFaniyPQlX
         15oxYS8A3nRnvR/CObl6eyOD7JSwE0cbRYWptrcwEgqTK/FEB5iBLFt6P2MsSJvKNqoV
         6BvMv+mzxysjVEK68eRErHIV0qjjnA4Qqc6zHXNXCei+DU1g+7gHCGezza325RLeaN4o
         +3qiXWiYrND8bzRbW1RLj6SSzhW9pBEg8TfkpjCgNqANG1ZDp2Euyer0MYgxUIQ61k+P
         oJGuy34DBIjX6n2o3GJCk8tNzaRu9ALla6PyQEvWAj6hMSedxxPFvIIVOsywSBExBv3n
         oNFQ==
X-Gm-Message-State: APjAAAXgdsm0GXRAbC6PKr2lKiFtChLTt0huDdchgwlneFacyhT798L2
        ozMSDUN4S3FOQdikRsdcqawEslg=
X-Google-Smtp-Source: APXvYqzJIjaNZuyFQUqGrPWsHOmq52z9FK67NWmx4gD0loM7QBLLQYZhN782UM8+xkn8VIV466aJMg==
X-Received: by 2002:a0c:b0ef:: with SMTP id p44mr62079552qvc.27.1564819521203;
        Sat, 03 Aug 2019 01:05:21 -0700 (PDT)
Received: from lud1.home ([177.17.22.67])
        by smtp.gmail.com with ESMTPSA id g23sm665983qtq.49.2019.08.03.01.05.19
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 03 Aug 2019 01:05:20 -0700 (PDT)
Date:   Sat, 3 Aug 2019 05:05:17 -0300
From:   Luciano ES <lucmove@gmail.com>
To:     XFS mailing list <linux-xfs@vger.kernel.org>
Subject: Re: XFS file system corruption, refuses to mount
Message-ID: <20190803050517.55b15f57@lud1.home>
In-Reply-To: <20190803011106.GJ7138@magnolia>
References: <20181211183203.7fdbca0f@lud1.home>
        <20190803011106.GJ7138@magnolia>
X-Mailer: Claws Mail 3.14.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, 2 Aug 2019 18:11:06 -0700, Darrick J. Wong wrote:

> > Is there something I can do to recover the data?  
> 
> Try xfs_repair -n to see what it would do if you ran repair?

I tried it. It took a very long time.

Phase 1 - find and verify superblock...
bad primary superblock - bad magic number !!!

attempting to find secondary superblock...
...................................... (a million dots)
Sorry, could not find valid secondary superblock
Exiting now.

I tested the file system (unlocked) with the fsck, lsblk, blkid and 
file commands, all of which confirm that it is an XFS file system. 
It just won't mount. Is there any recovery procedure?

-- 
Luciano ES
>>
