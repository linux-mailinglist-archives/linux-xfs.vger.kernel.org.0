Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF45E58CE
	for <lists+linux-xfs@lfdr.de>; Sat, 26 Oct 2019 07:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725966AbfJZFrs (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 26 Oct 2019 01:47:48 -0400
Received: from verein.lst.de ([213.95.11.211]:54272 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725843AbfJZFrs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 26 Oct 2019 01:47:48 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id CC7CF68BFE; Sat, 26 Oct 2019 07:47:46 +0200 (CEST)
Date:   Sat, 26 Oct 2019 07:47:46 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        Ian Kent <raven@themaw.net>
Subject: Re: [PATCH 5/7] xfs: remove the iosizelog variable in xfs_parseargs
Message-ID: <20191026054746.GB14648@lst.de>
References: <20191025174026.31878-1-hch@lst.de> <20191025174026.31878-6-hch@lst.de> <31757020-becb-1a54-645b-8bce2c5edf44@sandeen.net> <9817805f-27f0-93bc-2a54-ad0e82c0493b@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9817805f-27f0-93bc-2a54-ad0e82c0493b@sandeen.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 25, 2019 at 02:03:06PM -0500, Eric Sandeen wrote:
> sorry make that "-o allocsize=0"
> 
> Which I guess /is/ documented as being invalid, we just never rejected it
> before.
> 
> Still a change in behavior and worth being explicit about I think.

I'll updated the changelog to mention that.
