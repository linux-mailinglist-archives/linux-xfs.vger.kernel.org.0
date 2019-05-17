Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E01822155A
	for <lists+linux-xfs@lfdr.de>; Fri, 17 May 2019 10:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727689AbfEQI2J (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 17 May 2019 04:28:09 -0400
Received: from verein.lst.de ([213.95.11.211]:36140 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727581AbfEQI2I (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 17 May 2019 04:28:08 -0400
Received: by newverein.lst.de (Postfix, from userid 2407)
        id 0812368B05; Fri, 17 May 2019 10:27:48 +0200 (CEST)
Date:   Fri, 17 May 2019 10:27:47 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/20] xfs: merge xfs_efd_init into xfs_trans_get_efd
Message-ID: <20190517082747.GA13863@lst.de>
References: <20190517073119.30178-1-hch@lst.de> <20190517073119.30178-14-hch@lst.de> <790a6cfb-7fb9-db50-05c4-ba91fb7628b0@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <790a6cfb-7fb9-db50-05c4-ba91fb7628b0@suse.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 17, 2019 at 11:16:52AM +0300, Nikolay Borisov wrote:
> xfs_efd_log is really a struct which ends with an array. I think it will
> make it slightly more obvious if you use the newly introduced
> struct_size like so:
> 
> kmem_zalloc(struct_size(efdp, efd_format.efd_extents, nextents -1),
> KM_SLEEP)

If we do that we should also kill the fake first entry in the array
and make it a C99 flexible array.  But that should be done in a separate
patch.
