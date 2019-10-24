Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85E33E34FC
	for <lists+linux-xfs@lfdr.de>; Thu, 24 Oct 2019 16:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404616AbfJXOFv (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 24 Oct 2019 10:05:51 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:36235 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730547AbfJXOFv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Oct 2019 10:05:51 -0400
Received: by mail-ed1-f65.google.com with SMTP id bm15so1205680edb.3
        for <linux-xfs@vger.kernel.org>; Thu, 24 Oct 2019 07:05:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=plexistor-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zivCGSDpCNczJBDnbRKFgwtg6V3eZL1fJK4spMUzb2M=;
        b=xiDEpWnZCwSMVLCp3VPqS4sm+wVW/sdnBHghHZBCQLCx/g5K9AK4KLleVMeeWmtxsG
         Qw+i/fiW0MHZoLgVWMKlJZIhfsqDMsFG9TYX98zZmDf0nWZWnwamGE669GVR7DAdM8v1
         ijnxZRVMR8Agpt4s28FY3a9pGr/wgMisj1Mf0RnhmOK8fOYvfxYgSl1XbEPP4P3yyVr3
         nwHlO0p8pN3OxvezUkTIFY9tHGZq+OvNzG68h4/9d3iIzW4I6VQ/3zr876T5NVPSsVRX
         RYi0efbf1XB+hQ9wEuRmLiBkVs/69sZ021dMhtWGTlzc0sbtZgWvt2mEjWUIwkgXd8A4
         8x0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zivCGSDpCNczJBDnbRKFgwtg6V3eZL1fJK4spMUzb2M=;
        b=RnQAXnu+rjrycXTBjjyUpYmNDsKF4vyWOiFeOquXyIjOssaJSiraU8ap1SWHdFM5Uv
         IKo3dvqX3Qxm9BuiXSKW81JfGP1rZqdGYzWNZ6YmJRFbGUfx2EU/Ks7IVOiJW+gWUELk
         XodOenYOGfRK4uDEdbd8HpL1gE8buqWLPuu1uzM269POIy3bJxG1yZevLeVPimjO/Vfd
         T8pSYKel/owLoEmazgN5avdohivrAdmGkYLuAiJ0uXe06zK441XKiUWBbFuMsg+aMdsm
         IpDqNRcoDTWJAqJEGPGeMcUvjmWcVAuMWXnK6w33D/dorzCpscCuB8JXhdMbP3zBlV5q
         lYPg==
X-Gm-Message-State: APjAAAXbbsrxjyQV5t0Dz/cO3EYOJI4ilwLDM4/RdEBbb397U2SptP7w
        ElzxbtMzSnrM8EeNu8vGmcY6mQ==
X-Google-Smtp-Source: APXvYqy7P2no6DZvldA2LICLZwT8ebAbBZXsp8Vvhu48vH6AfqYXjLLCVmSZDmjIKjV6nzZIPdFnMQ==
X-Received: by 2002:a17:906:1e55:: with SMTP id i21mr39029914ejj.47.1571925949397;
        Thu, 24 Oct 2019 07:05:49 -0700 (PDT)
Received: from [10.68.217.182] ([217.70.210.43])
        by smtp.googlemail.com with ESMTPSA id y7sm564739edb.97.2019.10.24.07.05.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Oct 2019 07:05:48 -0700 (PDT)
Subject: Re: [PATCH 0/5] Enable per-file/directory DAX operations
To:     Dave Chinner <david@fromorbit.com>,
        Boaz Harrosh <boaz@plexistor.com>
Cc:     ira.weiny@intel.com, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        "Theodore Y. Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
References: <20191020155935.12297-1-ira.weiny@intel.com>
 <b7849297-e4a4-aaec-9a64-2b481663588b@plexistor.com>
 <b883142c-ecfe-3c5b-bcd9-ebe4ff28d852@plexistor.com>
 <20191023221332.GE2044@dread.disaster.area>
 <efffc9e7-8948-a117-dc7f-e394e50606ab@plexistor.com>
 <20191024073446.GA4614@dread.disaster.area>
From:   Boaz Harrosh <boaz@plexistor.com>
Message-ID: <fb4f8be7-bca6-733a-7f16-ced6557f7108@plexistor.com>
Date:   Thu, 24 Oct 2019 17:05:45 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <20191024073446.GA4614@dread.disaster.area>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 24/10/2019 10:34, Dave Chinner wrote:
> On Thu, Oct 24, 2019 at 05:31:13AM +0300, Boaz Harrosh wrote:
<>
> 
> The on disk DAX flag is inherited from the parent directory at
> create time. Hence an admin only need to set it on the data
> directory of the application when first configuring it, and
> everything the app creates will be configured for DAX access
> automatically.
> 

Yes I said that as well. But again I am concerned that this is the
opposite of our Intention. As you said the WRITEs are slow and
do not scale so what we like, and why we have the all problem, is
to WRITE *none*-DAX. And if so then how do we turn the bit ON later
for the fast READs.

> Or, alternatively, mkfs sets the flag on the root dir so that
> everything in the filesystem uses DAX by default (through
> inheritance) unless the admin turns off the flag on a directory
> before it starts to be used

> or on a set of files after they have
> been created (because DAX causes problems)...
> 

Yes exactly this can not be done currently.

> So, yeah, there's another problem with the basic assertion that we
> only need to allow the on disk flag to be changed on zero length
> files: we actually want to be able to -clear- the DAX flag when the
> file has data attached to it, not just when it is an empty file...
> 

Exactly, This is my concern. And the case that I see most useful is the
opposite where I want to turn it ON, for DAX fast READs.

>> What if, say in XFS when setting the DAX-bit we take all the three write-locks
>> same as a truncate. Then we check that there are no active page-cache mappings
>> ie. a single opener. Then allow to set the bit. Else return EBUISY. (file is in use)
> 
> DAX doesn't have page cache mappings, so anything that relies on
> checking page cache state isn't going to work reliably. 

I meant on the opposite case, Where the flag was OFF and I want it ON for
fast READs. In that case if I have any users there are pages on the
xarray.
BTW the opposite is also true if we have active DAX users we will have
DAX entries in the xarray. What we want is that there are *no* active
users while we change the file-DAX-mode. Else we fail the change.

> I also seem
> to recall that there was a need to take some vm level lock to really
> prevent page fault races, and that we can't safely take that in a
> safe combination with all the filesystem locks we need.
> 

We do not really care with page fault races in the Kernel as long
as I protect the xarray access and these are protected well if we
take truncate locking. But we have a bigger problem that you pointed
out with the change of the operations vector pointer.

I was thinking about this last night. One way to do this is with
file-exclusive-lock. Correct me if I'm wrong:
file-exclusive-readwrite-lock means any other openers will fail and
if there are openers already the lock will fail. Which is what we want
no? to make sure we are the exclusive user of the file while we change
the op vector.
Now the question is if we force the application to take the lock and
Kernel only check that we are locked. Or Kernel take the lock within
the IOCTL.

Lets touch base. As I understand the protocol we want to establish with
the administration tool is:

- File is created, written. read...

- ALL file handles are closed, there are no active users
- File open by single opener for the purpose of changing the DAX-mode
- lock from all other opens
- change the DAX-mode, op vectors
- unlock-exlusivness

- File activity can resume...

That's easy to say, But how can we enforce this protocol?

> Cheers,
> Dave.
> 

Thanks Dave
Boaz
