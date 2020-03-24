Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94D8A1907EB
	for <lists+linux-xfs@lfdr.de>; Tue, 24 Mar 2020 09:43:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726129AbgCXInI (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 24 Mar 2020 04:43:08 -0400
Received: from verein.lst.de ([213.95.11.211]:34517 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726091AbgCXInH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Mar 2020 04:43:07 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id BE9DC68B05; Tue, 24 Mar 2020 09:43:04 +0100 (CET)
Date:   Tue, 24 Mar 2020 09:43:04 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Christoph Hellwig <hch@lst.de>, guaneryu@gmail.com,
        jtulak@redhat.com, fstests@vger.kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfstests: remove xfs/191-input-validation
Message-ID: <20200324084304.GA25318@lst.de>
References: <20200318172115.1120964-1-hch@lst.de> <20200319043306.GK14282@dhcp-12-102.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200319043306.GK14282@dhcp-12-102.nay.redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 19, 2020 at 12:33:06PM +0800, Zorro Lang wrote:
> On Wed, Mar 18, 2020 at 06:21:15PM +0100, Christoph Hellwig wrote:
> > This test has constantly failed since it was added, and the promised
> > input validation never materialized.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> 
> Hmm... that's truth this case always fails. But a mkfs.xfs sanity test is
> good.
> 
> We have a RHEL internal mkfs.xfs sanity test case, but it takes long time to
> run, can't port to xfstests directly.
> I don't know if Jan would like to improve this case, might make it simple,
> remove those unstable test lines, rewrite the case to avoid unstable test
> results? Or we remove this case, then write a new one?
> I can do that too, if the xfs-devel thinks it worth.

Fine with me, but we really need to get rid of tests failing for no
good reason.  And given that there hasn't been any action for years
just removing this test seems like the by far best option.
