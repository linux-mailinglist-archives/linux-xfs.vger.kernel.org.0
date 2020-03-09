Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86CEA17DA36
	for <lists+linux-xfs@lfdr.de>; Mon,  9 Mar 2020 09:05:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725962AbgCIIFs (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 9 Mar 2020 04:05:48 -0400
Received: from verein.lst.de ([213.95.11.211]:46559 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725796AbgCIIFr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 9 Mar 2020 04:05:47 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id C3F1468B20; Mon,  9 Mar 2020 09:05:44 +0100 (CET)
Date:   Mon, 9 Mar 2020 09:05:44 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 7/7] xfs: kill XLOG_STATE_IOERROR
Message-ID: <20200309080544.GD31481@lst.de>
References: <20200306143137.236478-1-hch@lst.de> <20200306143137.236478-8-hch@lst.de> <20200306171545.GJ2773@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200306171545.GJ2773@bfoster>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 06, 2020 at 12:15:45PM -0500, Brian Foster wrote:
> If we were to first significantly reduce the number of error state
> checks required throughout this code (i.e. reduced to the minimum
> critical points necessary that ensure we don't do more log I/O or other
> "bad things"), _then_ I see the value of a patch to kill off the error
> state. Until we get to that point, this kind of strikes me as
> rejiggering complexity around. For example, things like how
> xlog_state_do_callback() passes ioerror to
> xlog_state_iodone_process_iclog(), which assigns it based on shutdown
> state, only for the caller to also check the shutdown state again are
> indication that more cleanup is in order before killing off the state.

I've added a few more patches fixing up some low hanging fruit and
completely redoing the code structure around
xlog_state_iodone_process_iclog.  Although that means the series keeps
growing, so I might split it into multiple series with some easier
prep patches and then the bigger changes in a second round.
