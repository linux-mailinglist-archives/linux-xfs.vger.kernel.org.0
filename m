Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3158285B4F
	for <lists+linux-xfs@lfdr.de>; Thu,  8 Aug 2019 09:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731231AbfHHHND (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 8 Aug 2019 03:13:03 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37088 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731226AbfHHHND (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Aug 2019 03:13:03 -0400
Received: by mail-wr1-f67.google.com with SMTP id b3so1400053wro.4
        for <linux-xfs@vger.kernel.org>; Thu, 08 Aug 2019 00:13:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=09eS3B5YsAIGDdz72NdEnBFq0HGw3rd9RYxiiux5kKQ=;
        b=N9R4Ji5ej8PZ85d6L0Ily2sfLnYaoN3/2lKBiT6rTYsgcc2USPhgSpU2hyRt6VZ88R
         VpcgIL8HDiYSpG6f0Xo0/7SWkEf0deNRr2YLoCLbZPvmwDnI/PyxNx5WuaAt4y9Hrcqi
         Ju4vNrNUVWh7uP4ixiXy6Jn6X79DoKkKXUcanm6r1eP+DRlAGEIdIFygQGXS+GZ5xAdo
         mXJwkKAeYLH9FD/D+YRZcrOXguxLDY34FBESDmP8q87M56CeYM8CAloPhVWOKWA6qATz
         RH29C4hcfkKNAe0wWIho3O9V9YTWPhyhpcQph1lTyJZ8v9wkNCWuR7nta0PolwO2ORmh
         fEqQ==
X-Gm-Message-State: APjAAAX1hLz9wWn6BMs63Gp+pnFEVgzEI62N7soXQgjuU7Kq2HAw4fWp
        mOmtU14Vzfuizd1WLQaqEJJjhQ==
X-Google-Smtp-Source: APXvYqx55fTYFIWx4y8CMX/mAs6x+m8zJCQLUEoqfwSf8FquZ6xBhJXCxbBFo9YaWa3MNeJyHK3GYw==
X-Received: by 2002:a5d:52c5:: with SMTP id r5mr14745465wrv.146.1565248380893;
        Thu, 08 Aug 2019 00:13:00 -0700 (PDT)
Received: from pegasus.maiolino.io (ip-89-103-126-188.net.upcbroadband.cz. [89.103.126.188])
        by smtp.gmail.com with ESMTPSA id i66sm2802240wmi.11.2019.08.08.00.12.59
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 00:13:00 -0700 (PDT)
Date:   Thu, 8 Aug 2019 09:12:58 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-fsdevel@vger.kernel.org, hch@lst.de, adilger@dilger.ca,
        jaegeuk@kernel.org, miklos@szeredi.hu, rpeterso@redhat.com,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/9] fibmap: Use bmap instead of ->bmap method in
 ioctl_fibmap
Message-ID: <20190808071257.ufbk5i35xpkf4byh@pegasus.maiolino.io>
Mail-Followup-To: Luis Chamberlain <mcgrof@kernel.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-fsdevel@vger.kernel.org, hch@lst.de, adilger@dilger.ca,
        jaegeuk@kernel.org, miklos@szeredi.hu, rpeterso@redhat.com,
        linux-xfs@vger.kernel.org
References: <20190731141245.7230-1-cmaiolino@redhat.com>
 <20190731141245.7230-5-cmaiolino@redhat.com>
 <20190731231217.GV1561054@magnolia>
 <20190802091937.kwutqtwt64q5hzkz@pegasus.maiolino.io>
 <20190802151400.GG7138@magnolia>
 <20190805102729.ooda6sg65j65ojd4@pegasus.maiolino.io>
 <20190805151258.GD7129@magnolia>
 <20190806224138.GW30113@42.do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190806224138.GW30113@42.do-not-panic.com>
User-Agent: NeoMutt/20180716
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> > 
> > > Maybe I am not seeing something or having a different thinking you have, but
> > > this is the behavior we have now, without my patches. And we can't really change
> > > it; the user view of this implementation.
> > > That's why I didn't try to change the result, so the truncation still happens.
> > 
> > I understand that we're not generally supposed to change existing
> > userspace interfaces, but the fact remains that allowing truncated
> > responses causes *filesystem corruption*.
> > 
> > We know that the most well known FIBMAP callers are bootloaders, and we
> > know what they do with the information they get -- they use it to record
> > the block map of boot files.  So if the IPL/grub/whatever installer
> > queries the boot file and the boot file is at block 12345678901 (a
> > 34-bit number), this interface truncates that to 3755744309 (a 32-bit
> > number) and that's where the bootloader will think its boot files are.
> > The installation succeeds, the user reboots and *kaboom* the system no
> > longer boots because the contents of block 3755744309 is not a bootloader.
> > 
> > Worse yet, grub1 used FIBMAP data to record the location of the grub
> > environment file and installed itself between the MBR and the start of
> > partition 1.  If the environment file is at offset 1234578901, grub will
> > write status data to its environment file (which it thinks is at
> > 3755744309) and *KABOOM* we've just destroyed whatever was in that
> > block.
> > 
> > Far better for the bootloader installation script to hit an error and
> > force the admin to deal with the situation than for the system to become
> > unbootable.  That's *why* the (newer) iomap bmap implementation does not
> > return truncated mappings, even though the classic implementation does.
> > 
> > The classic code returning truncated results is a broken behavior.
> 
> How long as it been broken for? And if we do fix it, I'd just like for
> a nice commit lot describing potential risks of not applying it. *If*
> the issue exists as-is today, the above contains a lot of information
> for addressing potential issues, even if theoretical.
> 

It's broken since forever. This has always been the FIBMAP behavior.


>   Luis

-- 
Carlos
