Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B47E51E64
	for <lists+linux-xfs@lfdr.de>; Tue, 25 Jun 2019 00:37:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbfFXWhG (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 24 Jun 2019 18:37:06 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:46814 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726413AbfFXWhG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jun 2019 18:37:06 -0400
Received: from dread.disaster.area (pa49-195-139-63.pa.nsw.optusnet.com.au [49.195.139.63])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 43F8A43AF7E;
        Tue, 25 Jun 2019 08:37:02 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1hfXZ4-0000PL-LQ; Tue, 25 Jun 2019 08:35:54 +1000
Date:   Tue, 25 Jun 2019 08:35:54 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Ian Kent <raven@themaw.net>, linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 02/10] xfs: mount-api - refactor suffix_kstrtoint()
Message-ID: <20190624223554.GA7777@dread.disaster.area>
References: <156134510205.2519.16185588460828778620.stgit@fedora-28>
 <156134510851.2519.2387740442257250106.stgit@fedora-28>
 <20190624172943.GV5387@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190624172943.GV5387@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0 cx=a_idp_d
        a=fNT+DnnR6FjB+3sUuX8HHA==:117 a=fNT+DnnR6FjB+3sUuX8HHA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=dq6fvYVFJ5YA:10
        a=7-415B0cAAAA:8 a=hMHMsTzsTvGR3Hs4IMAA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 24, 2019 at 10:29:43AM -0700, Darrick J. Wong wrote:
> On Mon, Jun 24, 2019 at 10:58:30AM +0800, Ian Kent wrote:
> > The mount-api doesn't have a "human unit" parse type yet so
> > the options that have values like "10k" etc. still need to
> > be converted by the fs.
> 
> /me wonders if that ought to be lifted to fs_parser.c, or is xfs the
> only filesystem that has mount options with unit suffixes?

I've suggested the same thing (I've seen this patchset before :)
and ISTR it makes everything easier if we just keep it here for this
patchset and then lift it once everything is merged...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
