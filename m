Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA5A52923
	for <lists+linux-xfs@lfdr.de>; Tue, 25 Jun 2019 12:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727901AbfFYKMT (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 25 Jun 2019 06:12:19 -0400
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:53347 "EHLO
        cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727763AbfFYKMS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jun 2019 06:12:18 -0400
X-Greylist: delayed 324 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Jun 2019 06:12:17 EDT
Received: (qmail 21237 invoked from network); 25 Jun 2019 12:06:52 +0200
X-Fcrdns: No
Received: from phoffice.de-nserver.de (HELO [10.11.11.165]) (185.39.223.5)
  (smtp-auth username hostmaster@profihost.com, mechanism plain)
  by cloud1-vm154.de-nserver.de (qpsmtpd/0.92) with (ECDHE-RSA-AES256-GCM-SHA384 encrypted) ESMTPSA; Tue, 25 Jun 2019 12:06:52 +0200
Subject: Re: [PATCH 2/2] xfs: implement cgroup aware writeback
To:     Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <20190624134315.21307-1-hch@lst.de>
 <20190624134315.21307-3-hch@lst.de> <20190624162215.GS5387@magnolia>
 <20190625100057.GD1462@lst.de>
From:   Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Message-ID: <044a8a27-ad1c-73ff-5a29-189f0b38c3d9@profihost.ag>
Date:   Tue, 25 Jun 2019 12:06:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190625100057.GD1462@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: de-DE
Content-Transfer-Encoding: 7bit
X-User-Auth: Auth by hostmaster@profihost.com through 185.39.223.5
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Am 25.06.19 um 12:00 schrieb Christoph Hellwig:
> On Mon, Jun 24, 2019 at 09:22:15AM -0700, Darrick J. Wong wrote:
>> On Mon, Jun 24, 2019 at 03:43:15PM +0200, Christoph Hellwig wrote:
>>> Link every newly allocated writeback bio to cgroup pointed to by the
>>> writeback control structure, and charge every byte written back to it.
>>>
>>> Tested-by: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
>>
>> Was this tested by running shared/011?  Or did it involve other checks?
> 
> I verified it with shared/011 and local frobbing.  Stefan can chime
> in on what testing he did.

I ran some real life Tests:

1.) using Dovecot for IMAP and limit Disk I/O

2.) Using dd without oflag=direct in systemd slices.

3.) Limit apache slice with various PHP applications in it.

Greets,
Stefan
