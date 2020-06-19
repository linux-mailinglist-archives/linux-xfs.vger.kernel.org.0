Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ECC3201908
	for <lists+linux-xfs@lfdr.de>; Fri, 19 Jun 2020 19:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391373AbgFSRDj (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 19 Jun 2020 13:03:39 -0400
Received: from sandeen.net ([63.231.237.45]:51022 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733192AbgFSRDi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 19 Jun 2020 13:03:38 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 2893211643;
        Fri, 19 Jun 2020 12:03:12 -0500 (CDT)
Subject: Re: Bug#953537: xfsdump fails to install in /usr merged system.
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        peter green <plugwash@p10link.net>,
        Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <998fa1cb-9e9f-93cf-15f0-e97e5ec54e9a@p10link.net>
 <20200619044734.GB11245@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <ea662f0b-7e73-0bbe-33aa-963389b9e215@sandeen.net>
Date:   Fri, 19 Jun 2020 12:03:35 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200619044734.GB11245@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 6/18/20 11:47 PM, Darrick J. Wong wrote:
> On Fri, Jun 19, 2020 at 05:05:00AM +0100, peter green wrote:
>> (original message was sent to nathans@redhat.com
>> 953537@bugs.debian.org and linux-xfs@vger.kernel.org re-sending as
>> plain-text only to linux-xfs@vger.kernel.org)
>>
>> This bug has now caused xfsdump to be kicked out of testing which is
>> making amanda unbuildable in testing.
> 
> Uhoh...
> 
>>
>>
>>> Yes, what's really needed here is for a change to be merged upstream
>>> (as all other deb packaging artifacts are) otherwise this will keep
>>> getting lost in time.
>> To make it easier to upstream this I whipped up a patch that should
>> solve the issue while only modifying the debian packaging and not
>> touching the upstream makefiles. It is attached to this message and if
>> I get no response I will likely do some further testing and then NMU
>> it in Debian.
>>
>> One issue I noticed is it's not all all obvious who upstream is. The
>> sgi website listed in README seems to be long dead and there are no
>> obvious upstream results in a google search for xfsdump. Gentoos page
>> on xfsdump links to https://xfs.wiki.kernel.org but that page makes no
>> mention of xfsdump.
>>
>> I eventually poked around on git.kernel.org and my best guess is that
>> https://git.kernel.org/pub/scm/fs/xfs/xfsdump-dev.git/ is the upstream
>> git repository and linux-xfs@vger.kernel.org is the appropriate
>> mailing list, I would appreciate comments on whether or not this is
>> correct and updates to the documentation to reflect whatever the
>> correct location is.
> 
> Yep, you've found us. :)
> 
> Uh... seeing how /sbin seems to be a symlink to /usr/sbin on more and
> more distros now, how about we just change the upstream makefile to dump
> them in /usr/sbin and forget all about the symlinks?
> 
> (He says, wondering what the actual maintainer will say...)

I wonder too :P

So, FWIW, fedora/rhel packaging also hacks this up :(

xfsdump does:

%install
rm -rf $RPM_BUILD_ROOT
make DIST_ROOT=$RPM_BUILD_ROOT install
# remove non-versioned docs location
rm -rf $RPM_BUILD_ROOT/%{_datadir}/doc/xfsdump/

# Bit of a hack to move files from /sbin to /usr/sbin
(cd $RPM_BUILD_ROOT/%{_sbindir}; rm xfsdump xfsrestore)
(cd $RPM_BUILD_ROOT/%{_sbindir}; mv ../../sbin/xfsdump .)
(cd $RPM_BUILD_ROOT/%{_sbindir}; mv ../../sbin/xfsrestore .)

xfsprogs does:

%install
make DIST_ROOT=$RPM_BUILD_ROOT install install-dev \
        PKG_ROOT_SBIN_DIR=%{_sbindir} PKG_ROOT_LIB_DIR=%{_libdir}

Both of these work around the default location of /sbin:

# grep PKG_ROOT_SBIN_DIR xfsprogs-maint/include/builddefs xfsdump/include/builddefs
xfsprogs-maint/include/builddefs:PKG_ROOT_SBIN_DIR = /sbin
xfsdump/include/builddefs:PKG_ROOT_SBIN_DIR = /sbin

On one hand, it'd be easy enough to change the upstream defaults I guess.
On the other hand, I think the PKG_ROOT_SBIN_DIR method is easy too.

How does debian fix this for xfsprogs?  Doesn't the same issue exist?

-Eric
