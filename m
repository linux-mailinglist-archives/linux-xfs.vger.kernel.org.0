Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09FB4B687C
	for <lists+linux-xfs@lfdr.de>; Wed, 18 Sep 2019 18:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729457AbfIRQuD (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 18 Sep 2019 12:50:03 -0400
Received: from verein.lst.de ([213.95.11.211]:34549 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726559AbfIRQuD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 18 Sep 2019 12:50:03 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 8590D68B20; Wed, 18 Sep 2019 18:50:00 +0200 (CEST)
Date:   Wed, 18 Sep 2019 18:50:00 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: shortcut xfs_file_release for read-only file
 descriptors
Message-ID: <20190918165000.GB19316@lst.de>
References: <20190916122041.24636-1-hch@lst.de> <20190916122041.24636-3-hch@lst.de> <20190916125323.GC41978@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190916125323.GC41978@bfoster>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 16, 2019 at 08:53:23AM -0400, Brian Foster wrote:
> Didn't Dave have a variant of this patch for dealing with a
> fragmentation issue (IIRC)? Anyways, seems fine:

I don't really remember one.  But maybe Dave can chime in.
