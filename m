Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60409520B6
	for <lists+linux-xfs@lfdr.de>; Tue, 25 Jun 2019 04:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbfFYCpw (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 24 Jun 2019 22:45:52 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:44625 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726451AbfFYCpw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jun 2019 22:45:52 -0400
Received: by mail-pf1-f196.google.com with SMTP id t16so8609347pfe.11;
        Mon, 24 Jun 2019 19:45:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=XQJYHtvW6pfFlI/jd9ilg5Syrlcwv+1do7PlJ2nmdko=;
        b=ohXHJeVXrSkmdrKwLXwiaAdaZiIx+WPz9Nq7ERKFBE4Vj0/3rSFOMVIXftX5KWMnmS
         0vT+vZGj6Jv2k6xwFnv5MKh6KB+++bFP6h2p7xT0s8fTz+/cuX6UxAkDxtbXbCZy/K5+
         EFjxtjCwZJmqFzoHignQvHeub6NojhvqLd+wD5TPuZTDYIf+QZJ6JekiWWEs375h5NvG
         sihikov12lrjtLlVikAufyq6X+1YR6dtX5t7DmALaQ9tqBh9NoaAkA93h4FDMSIsDItV
         C8PgdXRFTP+bYcNBOsrsPLw1noMgrO60j5suY0nHe7Pz2UL3zVPGeiom9W/NL8DElPaL
         RAqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=XQJYHtvW6pfFlI/jd9ilg5Syrlcwv+1do7PlJ2nmdko=;
        b=B1vhhi3wPxKOT8lrZX4nUiT1xvP592VG8MR9f9LrCu8IY6Quw2LokzdgzIhrJ0MSmZ
         CwS8Pz5lSexlX+Tw5UaG/rcmLwg3PF8H6lgVOKUeH+AswIsdxVl7JeBIBR5utOyjIc+h
         CIyBGfmicHb/Ffj5Lph3VXxGJIaSVBi6Pi6ntQiS9dYtItMcBttFLJBtICPs5eqxmvn3
         LAjRX6DxK5kY6xupo7LEnVf3Zz/kI7NHxc5pzY5QoiqtjCZTDS5Y9MOxjuOqh7jY7vOQ
         Y3LWSuMhomrrtZ2widfl2rk9MxhgIEy7KjFFNvXaPJD8fJBEs+qVSFQuhWJbwNI0Q10I
         IfhA==
X-Gm-Message-State: APjAAAXynman4JogMAMWBqld0ysos3gCM0RdVSzzF+4A6zNTZOrynNjE
        Nt2ESJsE5Kw495wFSWZfVFk=
X-Google-Smtp-Source: APXvYqyAmK72U0N2MlYG5a+nNBOXjN43AsOoWsKEe/XK8pz1RB4unMSTjLJW8CXXiUQf8k7/cLjaIw==
X-Received: by 2002:a63:514e:: with SMTP id r14mr7119875pgl.71.1561430751687;
        Mon, 24 Jun 2019 19:45:51 -0700 (PDT)
Received: from localhost ([178.128.102.47])
        by smtp.gmail.com with ESMTPSA id f64sm10566700pfa.115.2019.06.24.19.45.50
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 24 Jun 2019 19:45:51 -0700 (PDT)
Date:   Tue, 25 Jun 2019 10:45:46 +0800
From:   Eryu Guan <guaneryu@gmail.com>
To:     Zorro Lang <zlang@redhat.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: test xfs_info on block device and mountpoint
Message-ID: <20190625024546.GO15846@desktop>
References: <20190622153827.4448-1-zlang@redhat.com>
 <20190623214919.GD5387@magnolia>
 <20190624012103.GF30864@dhcp-12-102.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190624012103.GF30864@dhcp-12-102.nay.redhat.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 24, 2019 at 09:21:03AM +0800, Zorro Lang wrote:
> On Sun, Jun 23, 2019 at 02:49:19PM -0700, Darrick J. Wong wrote:
> > On Sat, Jun 22, 2019 at 11:38:27PM +0800, Zorro Lang wrote:
> > > There was a bug, xfs_info fails on a mounted block device:
> > > 
> > >   # xfs_info /dev/mapper/testdev
> > >   xfs_info: /dev/mapper/testdev contains a mounted filesystem
> > > 
> > >   fatal error -- couldn't initialize XFS library
> > > 
> > > xfsprogs has fixed it by:
> > > 
> > >   bbb43745 xfs_info: use findmnt to handle mounted block devices
> > > 
> > > Signed-off-by: Zorro Lang <zlang@redhat.com>
> > 
> > Aha!  I remembered something -- xfs/449 already checks for consistency
> > in the various xfs geometry reports that each command provides, so why
> > not just add the $XFS_INFO_PROG $SCRATCH_DEV case at the end?
> 
> Wow, there're so many cases, can't sure what we've covered now:)
> 
> Sure, I can do this change on xfs/449, if Eryu thinks it's fine to increase
> the test coverage of a known case.

Given that we're having more and more tests and the test time grows
quickly, I'm fine now with adding such small & similar test to existing
test case to reuse the test setups, especially when XFS maintainer
agrees to do so :)

Thanks,
Eryu
