Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44AA03C140
	for <lists+linux-xfs@lfdr.de>; Tue, 11 Jun 2019 04:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390455AbfFKCgv (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 10 Jun 2019 22:36:51 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:33750 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390280AbfFKCgv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Jun 2019 22:36:51 -0400
Received: by mail-pf1-f193.google.com with SMTP id x15so6436294pfq.0;
        Mon, 10 Jun 2019 19:36:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Di/uVDNPzSHSeWFEAlJfe+4zGHaeODhjfgT1yZDb3I0=;
        b=QGxTmc1nZHhKxPbSUMas0tObWl+648N+Cgo2s5/GE/bcmE2MokSfRz81dsgsFAGQQI
         G5AEpliA8olR9U4sIfAXwhIzVT0VB303XprhMGz2TEvtP/ti6dVdeZeSvjuKUqr6lJVF
         vuJ5hVs2ujR3T3Uy3wgNAxJ9lj/rHe0N8nQdsH2o73wXRiTavUgCCtDMIKGVd2decj2N
         4nV6wiZDDXhxH/VYRCWPs5g9y7BpN2e0++XN0G75QwnulJChk+LLpJUR2j7Iyo/XOyQI
         nTPv6UjCMbbYilSGEyrXgzqbWrveWg3lnMuuZ+SDYYTm3Z/3SsMlfUImW6uMY6ZiATCF
         oPvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Di/uVDNPzSHSeWFEAlJfe+4zGHaeODhjfgT1yZDb3I0=;
        b=km76IpHwLrzuLMfiYcdp2UDQdwminLu4SL9fVgvxk4wj032a3Bdd4SSSzpIr8GLRQR
         PLEIthHdRzJC0S0/bBrydSbjWMONzHLLMQjOm2NTsO80eStzwbzt65E3RCk5KNUUsGj5
         FRNJwQh+L5YB+fIhJPjVba47Ca4dMOyIpKQc1sj+6HcRr6AKeir3F0pgww3cfXJHssu5
         olq2sa9PvN+gfxIEvMJMJfvKKTmtDTiZJHtl8wT2zvjE14kvJgTeyO109T95enOUI/qZ
         AH0/8C7eB5QTWOi8v16AhnOAIEgF8bzQkKmutxKRKJctiL8XgH4ddxkxk/QUiE5soc6C
         i/+g==
X-Gm-Message-State: APjAAAXPAPA2n/8eyt3AvfmfLvMbgGxujAgST1EJqtRu53Or6sdOv528
        YtXkAt7gW2oHO1x9JC/TkSY=
X-Google-Smtp-Source: APXvYqzuamjOWnma7oSoR0Xedc8ToCAakQHlXSwkyxfLpzRUOPdUFW94IXkCMC4hxvb4bT6ZT0gZYw==
X-Received: by 2002:a17:90a:8415:: with SMTP id j21mr3101315pjn.21.1560220610337;
        Mon, 10 Jun 2019 19:36:50 -0700 (PDT)
Received: from localhost ([47.254.35.144])
        by smtp.gmail.com with ESMTPSA id 144sm18434935pfy.54.2019.06.10.19.36.48
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 10 Jun 2019 19:36:49 -0700 (PDT)
Date:   Tue, 11 Jun 2019 10:36:47 +0800
From:   Eryu Guan <guaneryu@gmail.com>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Olga Kornievskaia <olga.kornievskaia@gmail.com>,
        fstests <fstests@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v3 3/6] generic: copy_file_range swapfile test
Message-ID: <20190611023647.GA15846@desktop>
References: <20190602124114.26810-1-amir73il@gmail.com>
 <20190602124114.26810-4-amir73il@gmail.com>
 <20190610035829.GA18429@mit.edu>
 <CAOQ4uxi-s6ncLGjh_u5x4DFK+dvcaobDCqup_ZV3mZOYDRuOEQ@mail.gmail.com>
 <20190610133131.GE15963@mit.edu>
 <20190611021222.GY15846@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190611021222.GY15846@desktop>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 11, 2019 at 10:12:22AM +0800, Eryu Guan wrote:
[snip]
> > 
> > > Do you think that should there be a different policy w.r.t timing of
> > > merging xfstests tests that fail on upstream kernel?
> > 
> > That's my opinion, and generic/484 is the best argument for why we
> > should wait.  Other people may have other opinions though, and I have
> > a workaround, so I don't feel super-strong about it.  (generic/454 is
> > now the second test in my global exclude file.  :-)
> 
> I don't see generic/454 failing with ext4 (I'm testing with default
> mkfs/mount options, kernel is 5.2-rc2). But IMHO, I think generic/454 is

Oh, I see, I think you meant generic/554 not generic/454 (thanks Darrick
for pointing that out :)

> different, it's not a targeted regression test, it's kind of generic
> test that should work for all filesystems.
> 
> > 
> > At the very *least* there should be a comment in the test that fix is
> > pending, and might not be applied yet, with a URL to the mailing list
> > discussion.  That will save effort when months (years?) go by, and the
> > fix still hasn't landed the upstream kernel....
> 
> Agreed, I've been making sure there's a comment referring to the fix or
> pending fix (e.g. only commit summary no hash ID) for such targeted
> regression tests.

And I took generic/55[34] as generic tests not targeted regression test.
But looks like it's better to reference the fixes anyway.

Amir, would you mind adding such references to generic/55[34] as well?

Thanks,
Eryu
