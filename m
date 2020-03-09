Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A165217DA2D
	for <lists+linux-xfs@lfdr.de>; Mon,  9 Mar 2020 09:03:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725956AbgCIID4 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 9 Mar 2020 04:03:56 -0400
Received: from verein.lst.de ([213.95.11.211]:46554 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725796AbgCIID4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 9 Mar 2020 04:03:56 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id EF09B68B20; Mon,  9 Mar 2020 09:03:54 +0100 (CET)
Date:   Mon, 9 Mar 2020 09:03:54 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/7] xfs: factor out a xlog_state_activate_iclog helper
Message-ID: <20200309080354.GC31481@lst.de>
References: <20200306143137.236478-1-hch@lst.de> <20200306143137.236478-6-hch@lst.de> <20200306171213.GH2773@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200306171213.GH2773@bfoster>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 06, 2020 at 12:12:13PM -0500, Brian Foster wrote:
> On Fri, Mar 06, 2020 at 07:31:35AM -0700, Christoph Hellwig wrote:
> > Factor out the code to mark an iclog a active into a new helper.
> 
> "mark as active" or just "mark active"

I've fixed this, but then replaced this patch with a bigger one
doing additional refactoring.
