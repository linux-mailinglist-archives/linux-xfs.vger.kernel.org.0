Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70E2857A16
	for <lists+linux-xfs@lfdr.de>; Thu, 27 Jun 2019 05:36:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbfF0Df7 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 26 Jun 2019 23:35:59 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:59919 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726462AbfF0Df7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Jun 2019 23:35:59 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 4D4F157E;
        Wed, 26 Jun 2019 23:35:58 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 26 Jun 2019 23:35:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm3; bh=
        WJYwLsOzf+mzRGr0yla0fCVBrtOHpczi61410VUNh1A=; b=bFOYWlQvYRhHc1P9
        6Sc0rLXKAJP1Iv3bxbB3kD5jX8EkOxqm82a3/xVsnmPAr0W6a2mB5v6jEpYpuZq7
        KpRpR7GAiN4mG1AA8bCByjt0XLVaXSj5Djg9MTL2ADORPT5YkPsQcgYcCwtCy/Au
        nFz80GxUTvSrp3deXsJGAabRaGXBjToR9Ck18FAUdUQyfJ38h3JA/h4KOzD+fdvQ
        y3n79q/+oDNwXCa0GqoejJNrmJlOm4NHjg42+CpVVktKafRwjOrXjz7usWVnL3RG
        egEtgwQVNpBHR4mmNdncIwQucWDcKoKXFJLlffJmsttVNjgx8Cr4NZY+PojzeB9k
        KtT+NQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=WJYwLsOzf+mzRGr0yla0fCVBrtOHpczi61410VUNh
        1A=; b=bszlC7V2Z4cDrlVyvmBD/DwZ5PJ8Hbkl6ZnU3wF4k5JguMzx/vxGMo1uA
        XKDsMQ88VMpwEt7xLg024BhuXUAPaDlwzDeBv7zueF91B/smAhZ2Lec5stzhArVI
        JRYbU8B13LVa9jB1bFf5t0+EO6RY5DMlWqWdq9w7MqAlkyUmAQdGFai804/ctT8b
        LCvAUbqeHEIQp/nj2ElZ4RUinpvNWIyoI9ycCdnRL++Rlwu1ZTNhPXt/+aOZL3rm
        B/LKd2FfK5DPkoHKef9+pza9wH9hSSetxhWvONtUPJA2y2x0TNbh9TTYgYdzqZRn
        FkmVC7u/am2fHrlfXIOW0RTyLfMJA==
X-ME-Sender: <xms:nTkUXcoO1iXxbFEFIrK0zws80OAMQFxFXqGbd_-mq9-kiDhLpLBXJA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudejgdejgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefkuffhvfffjghftggfggfgsehtjeertddtreejnecuhfhrohhmpefkrghnucfm
    vghnthcuoehrrghvvghnsehthhgvmhgrfidrnhgvtheqnecukfhppeduudekrddvtdekrd
    dujeefrdehfeenucfrrghrrghmpehmrghilhhfrhhomheprhgrvhgvnhesthhhvghmrgif
    rdhnvghtnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:nTkUXUEale0GKINyTQBXVbfodKjpnFSgiKH5a3HEorHoFiyFpyF_FQ>
    <xmx:nTkUXcnLtNRPAjooiKCQMFl5xIvHqKwB7B-ELUklf26Ry83QrAKrkw>
    <xmx:nTkUXQ9PvEX88yTH7i3bKWPgWnmeO1ytW_Hq6wZmcO2-hZ-6Wsh-Rw>
    <xmx:nTkUXYimScWCZHe23RrlWvManxveCuvGlC-PGvK57v07ScDWZ9eseQ>
Received: from pluto.themaw.net (unknown [118.208.173.53])
        by mail.messagingengine.com (Postfix) with ESMTPA id E1FA180060;
        Wed, 26 Jun 2019 23:35:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by pluto.themaw.net (Postfix) with ESMTP id 6DE2A1C011B;
        Thu, 27 Jun 2019 11:35:53 +0800 (AWST)
Message-ID: <224f3629edfceb8e36a91b9451366b80aaef15cd.camel@themaw.net>
Subject: Re: [PATCH 03/10] xfs: mount-api - add xfs_parse_param()
From:   Ian Kent <raven@themaw.net>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date:   Thu, 27 Jun 2019 11:35:53 +0800
In-Reply-To: <6dc984b1eb55d201c95314d146fbeafb45d71c03.camel@themaw.net>
References: <156134510205.2519.16185588460828778620.stgit@fedora-28>
         <156134511636.2519.2203014992522713286.stgit@fedora-28>
         <20190624172632.GU5387@magnolia>
         <6dc984b1eb55d201c95314d146fbeafb45d71c03.camel@themaw.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 2019-06-25 at 07:47 +0800, Ian Kent wrote:
> +	default:
> > > +		return invalf(fc, "XFS: unknown mount option [%s].", param-
> > > > key);
> > 
> > What do these messages end up looking like in dmesg?
> > 
> > The reason I ask is that today when mount option processing fails we log
> > the device name in the error message:
> > 
> > # mount /dev/sda1 /mnt -o gribblegronk
> > [64010.878477] XFS (sda1): unknown mount option [gribblegronk].
> > 
> > AFAICT using invalf (instead of xfs_warn) means that now we don't report
> > the device name, and all you'd get is:
> > 
> > "[64010.878477] XFS: unknown mount option [gribblegronk]."
> > 
> > which is not as helpful...
> 
> Yes, I thought that might be seen as a problem.
> 
> The device name was obtained from the super block in the the
> original code and the super block isn't available at this
> point.
> 
> Not sure what to do about it but I'll have a look.
> 

It turns out that I also made a mistake with the error string.

The above would actually print (something like):
[64010.878477] xfs: XFS: unknown mount option [gribblegronk]."

I can change the case of the struct fs_parameter_description
.name and leave out the "XFS" in the error string to fix that.

But, because the parameter parsing is done before super block
creation, there's no bdev to get a device name from.

There should be a source (block device path) filed set in
the fs context and I could dup the last component of that
or walk the path to resolve symlinks and dup the path
dentry d_name which should give (something like) the
device name.

But the printk %pg format is a bit different in the way
it constructs the name from the bdev so it could well be
different.

That could lead to confusion too.

Also, if an error is occurs in the VFS the message won't
have the device name either.

So I'm not sure what to do about this one, suggestions?

Ian

