Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9622A5082
	for <lists+linux-xfs@lfdr.de>; Mon,  2 Sep 2019 09:59:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729911AbfIBH7t (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 2 Sep 2019 03:59:49 -0400
Received: from verein.lst.de ([213.95.11.211]:47909 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729910AbfIBH7t (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 2 Sep 2019 03:59:49 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 7CE79227A8A; Mon,  2 Sep 2019 09:59:46 +0200 (CEST)
Date:   Mon, 2 Sep 2019 09:59:46 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: add a xfs_valid_startblock helper
Message-ID: <20190902075946.GB29137@lst.de>
References: <20190830102411.519-1-hch@lst.de> <20190830102411.519-2-hch@lst.de> <20190830150650.GA5354@magnolia> <20190830153253.GA20550@lst.de> <20190901073634.GA11777@lst.de> <20190901203140.GP5354@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190901203140.GP5354@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Sep 01, 2019 at 01:31:40PM -0700, Darrick J. Wong wrote:
> It's been mildly helpful for noticing when my online/offline repair
> prototype code totally screws up, but at that point so much magic smoke
> is already pouring out everywhere that it's hard not to notice. :)

That suggests to just keep the macro as I submitted it, maybe with
a big fat comment explaining the usage.
